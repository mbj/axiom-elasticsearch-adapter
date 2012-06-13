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

  context 'with inclusion predicate' do
    let(:input) { Function::Predicate::Inclusion.new(attribute,[1,2,3]) }

    it 'should return filter literal' do
      should == { :filter => { :terms => { :id => [1,2,3] } } }
    end
  end

  context 'with exclusion predicate' do
    let(:input) { Function::Predicate::Exclusion.new(attribute,[1,2,3]) }

    it 'should return filter literal' do
      should == { :filter => { :not => { :terms => { :id => [1,2,3] } } } }
    end
  end

  context 'with greater than predicate' do
    let(:input) { Function::Predicate::GreaterThan.new(attribute,1) }

    it 'should return filter literal' do
      should == { :filter => { :range => { :id => { :gt => 1 } } } } 
    end
  end

  context 'with greater than or equal to predicate' do
    let(:input) { Function::Predicate::GreaterThanOrEqualTo.new(attribute,1) }

    it 'should return filter literal' do
      should == { :filter => { :range => { :id => { :gte => 1 } } } } 
    end
  end

  context 'with less than predicate' do
    let(:input) { Function::Predicate::LessThan.new(attribute,1) }

    it 'should return filter literal' do
      should == { :filter => { :range => { :id => { :lt => 1 } } } } 
    end
  end

  context 'with less than or equal to predicate' do
    let(:input) { Function::Predicate::LessThanOrEqualTo.new(attribute,1) }

    it 'should return filter literal' do
      should == { :filter => { :range => { :id => { :lte => 1 } } } } 
    end
  end
end
