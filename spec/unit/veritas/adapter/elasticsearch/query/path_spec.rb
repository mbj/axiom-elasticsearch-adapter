require 'spec_helper'

describe Adapter::Elasticsearch::Query,'#to_query' do
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

  subject { object.path }

  it 'should return base relation name' do
    should == 'name'
  end
end
