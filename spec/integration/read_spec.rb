require 'spec_helper'

require 'logger'

describe Adapter::Elasticsearch, 'reading' do
  let(:uri)           { ENV.fetch('ES_URI', 'http://localhost:9200')                       }
  let(:logger)        { Logger.new($stdout)                                               }
  let(:adapter)       { Adapter::Elasticsearch.new(uri, :logger => logger)                 }
  let(:header)        { Relation::Header.new([ [:firstname, String], [:lastname, String] ]) }
  let(:base_relation) { Relation::Base.new('test/people', header)                          }

  let(:index_name)    { 'test'                                                            }

  let(:driver)        { adapter.driver                                                    }
  let(:connection)    { driver.connection                                                 }

  let(:relation)      { Adapter::Elasticsearch::Gateway.new(adapter, base_relation)        }

  # Driver does not allow writes currently
  def add(data)
    connection.post('test/people') do |request|
      request.options[:expect_status]=201
      request.options[:convert_json]=true
      request.body = data
    end
  end

  before :all do
    driver.drop(index_name)
    driver.setup(index_name,
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

    driver.wait(index_name, :timeout => 10)

    # Driver does not support writes (yet)

    add(:firstname => 'John', :lastname => 'Doe')
    add(:firstname => 'Sue', :lastname => 'Doe')

    # Ensure documents are searchable
    driver.refresh
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
