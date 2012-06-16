require 'spec_helper'

describe Adapter::Elasticsearch::Query,'#execute' do
  let(:object) { described_class.new(relation) } 

  let(:header) do
    [
      [:firstname,String],
      [:lastname,String]
    ]
  end

  let(:relation) do
    Veritas::Relation::Base.new(:name,header) 
  end

  let(:query) { object.to_query }
  let(:path)  { object.path     }

  let(:connection) { mock }
  let(:data)       { mock }

  subject { object.execute(connection) }

  before do
    connection.should_receive(:read).with(path,query).and_return(data)
  end

  it 'should return a result' do
    should be_kind_of(Adapter::Elasticsearch::Result)
  end

  it 'should be initialized with correct data' do
    subject.instance_variable_get(:@data).should be(data)
  end

  it 'should be initialized with correct relation' do
    subject.instance_variable_get(:@relation).should be(relation)
  end
end
