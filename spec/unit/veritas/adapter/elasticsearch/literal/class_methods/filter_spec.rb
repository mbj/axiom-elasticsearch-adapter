require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.filter' do
  let(:object) { Adapter::Elasticsearch::Literal }

  subject { object.filter(input) }

  let(:attribute) { Attribute::Integer.new(:id)       }

  let(:input) { Function::Predicate::Equality.new(attribute,1) }

  it 'should return filter literal' do
    should == { :filter => { :term => { :id => 1 } } }
  end
end
