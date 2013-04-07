require 'spec_helper'

describe Adapter::Elasticsearch::Adapter, '#read' do

  let(:uri)        { 'http://example.com:9200'        }
  let(:options)    { {}                               }
  let(:object)     { described_class.new(connection)  }
  let(:relation)   { mock('Relation')                 }
  let(:query)      { mock('Query')                    }
  let(:connection) { mock('Connection')               }
  let(:rows)       { [ [ 1 ], [ 2 ], [ 3 ] ]          }
  let(:yields)     { []                               }

  before do
    expectation = query.stub(:each)
    rows.each { |row| expectation.and_yield(row) }

    Adapter::Elasticsearch::Query.stub(:build => query)
  end

  context 'with a block' do
    subject { object.read(relation) { |row| yields << row } }

    it_should_behave_like 'a command method'

    it 'yields each row' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to(rows)
    end

    it 'initializes a query' do
      Adapter::Elasticsearch::Query.should_receive(:build).with(connection, relation).and_return(query)
      subject
    end
  end

  context 'without a block' do
    subject { object.read(relation) }

    it { should be_instance_of(to_enum.class) }
  end
end
