require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.filter' do
  let(:object) { Adapter::Elasticsearch::Literal }

  subject { object.filter(input) }

  let(:attribute) { Attribute::Integer.new(:id)       }

  context 'with equality predicate' do
    let(:input) { Function::Predicate::Equality.new(attribute,1) }

    it 'should return filter literal' do
      should == { :filter => { :term => { :id => 1 } } }
    end
  end

  context 'with inequality predicate' do
    let(:input) { Function::Predicate::Inequality.new(attribute,1) }

    it 'should return filter literal' do
      should == { :filter => { :not => { :term => { :id => 1 } } } }
    end
  end

  context 'with disjunction' do
    let(:left)  { Function::Predicate::Equality.new(attribute,1) }
    let(:right) { Function::Predicate::Equality.new(attribute,2) }
    let(:input) { Function::Connective::Disjunction.new(left,right) }

    it 'should return filter literal' do
      should == { :filter => { :or => [{ :term => { :id => 1 } },{:term => { :id => 2} } ] } }
    end
  end
end
