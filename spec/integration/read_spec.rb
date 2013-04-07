require 'spec_helper'

require 'logger'

describe Adapter::Elasticsearch, 'reading' do

  let(:uri)           { ENV.fetch('ES_URI', 'http://localhost:9200')                           }
  let(:logger)        { Logger.new($stdout)                                                    }
  let(:adapter)       { Adapter::Elasticsearch::Adapter.new(index)                             }
  let(:header)        { Relation::Header.coerce([ [:firstname, String], [:lastname, String] ]) }
  let(:base_relation) { Relation::Base.new('people', header)                                   }
  let(:cluster)       { Elasticsearch::Cluster.connect(uri, logger)                            }
  let(:index)         { cluster.index(index_name)                                              }
  let(:index_name)    { 'test'                                                                 }
  let(:relation)      { Adapter::Elasticsearch::Gateway.new(adapter, base_relation)            }

  def add(data)
    index.type('people').index_create(data)
  end

  before do
    index.delete if index.exist?
    index.create(
      :settings => {
        :number_of_shards => 1,
        :number_of_replicas => 0,
      },
      :mappings => {
        :people => {
          :properties => {
            :firstname => {
              :type => 'multi_field',
              :fields => {
                :firstname => { :type => 'string', :index => 'not_analyzed' },
                :search_firstname => { :type => 'string', :index => 'analyzed' }
              }
            },
            :lastname => {
              :type => 'multi_field',
              :fields => {
                :lastname => { :type => 'string', :index => 'not_analyzed' },
                :search_lastname => { :type => 'string', :index => 'analyzed' }
              }
            }
          }
        }
      }
    )

    cluster.health(:wait_for_status => :green)

    add(:firstname => 'John', :lastname => 'Doe')
    add(:firstname => 'Sue', :lastname => 'Doe')

    # Ensure documents are searchable
    index.refresh
  end

  specify 'it allows to receive all records' do
    data = relation.to_a
    data.should == [
      [ 'John', 'Doe' ],
      [ 'Sue', 'Doe' ]
    ]
  end

  specify 'it allows to receive specific records' do
    data = relation.restrict { |r| r.firstname.eq('John') }.to_a
    data.should == [ [ 'John', 'Doe' ] ]
  end
end
