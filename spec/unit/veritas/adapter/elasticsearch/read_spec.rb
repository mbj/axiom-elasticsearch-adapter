require 'spec_helper'

shared_examples_for 'a method that uses the elasticsearch driver' do
  let(:connection) { mock('Connection') }

  before do
    Adapter::Elasticsearch::Driver.stub!(:new).and_return(connection)
  end

  it 'opens a connection' do
    Adapter::Elasticsearch::Driver.should_receive(:new).with(uri, options).and_return(connection)
    subject
  end
end

describe Adapter::Elasticsearch, '#read' do
  let(:uri)       { 'http://example.com:9200'        }
  let(:options)   { {}                               }
  let(:object)    { described_class.new(uri, options) }
  let(:relation)  { mock('Relation')                 }
  let(:query)     { mock('Query')                }
  let(:rows)      { [ [ 1 ], [ 2 ], [ 3 ] ]          }
  let(:yields)    { []                               }

  before do
    expectation = query.stub(:each)
    rows.each { |row| expectation.and_yield(row) }

    described_class::Query.stub!(:build).and_return(query)
  end

  context 'with a block' do
    subject { object.read(relation) { |row| yields << row } }

    it_should_behave_like 'a method that uses the elasticsearch driver'
    it_should_behave_like 'a command method'

    it 'yields each row' do
      expect { subject }.to change { yields.dup }.
        from([]).
        to(rows)
    end

    it 'initializes a query' do
      described_class::Query.should_receive(:build).with(connection, relation).and_return(query)
      subject
    end
  end

  context 'without a block' do
    subject { object.read(relation) }

    it { should be_instance_of(to_enum.class) }
  end
end
