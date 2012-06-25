require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.filter' do
  subject { object.filter(restriction) }

  let(:object) { Adapter::Elasticsearch::Literal }

  let(:relation) { Relation::Base.new(:foo,[attribute]) }
  let(:restriction) { Algebra::Restriction.new(relation,predicate) }

  let(:attribute) { Attribute::Integer.new(:id)       }

  context 'with equality predicate' do
    let(:predicate) { Function::Predicate::Equality.new(attribute,1) }

    it 'should return filter literal' do
      should == { :term => { :id => 1 } }
    end
  end

  context 'with inequality predicate' do
    let(:predicate) { Function::Predicate::Inequality.new(attribute,1) }

    it 'should return filter literal' do
      should == { :not => { :term => { :id => 1 } } }
    end
  end

  context 'with disjunction' do
    let(:left)  { Function::Predicate::Equality.new(attribute,1) }
    let(:right) { Function::Predicate::Equality.new(attribute,2) }
    let(:predicate) { Function::Connective::Disjunction.new(left,right) }

    it 'should return filter literal' do
      should == { :or => [{ :term => { :id => 1 } },{:term => { :id => 2} } ] } 
    end
  end

  context 'with conjunction' do
    let(:left)  { Function::Predicate::Equality.new(attribute,1) }
    let(:right) { Function::Predicate::Equality.new(attribute,2) }
    let(:predicate) { Function::Connective::Conjunction.new(left,right) }

    it 'should return filter literal' do
      should == { :and => [{ :term => { :id => 1 } },{:term => { :id => 2} } ] } 
    end
  end

  context 'with negation' do
    let(:inner_predicate)  { Function::Predicate::Equality.new(attribute,1) }
    let(:predicate) { Function::Connective::Negation.new(inner_predicate) }

    it 'should return filter literal' do
      should == { :not => { :term => { :id => 1 } } }
    end
  end

  context 'with inclusion predicate' do
    let(:predicate) { Function::Predicate::Inclusion.new(attribute,[1,2,3]) }

    it 'should return filter literal' do
      should == { :terms => { :id => [1,2,3] } }
    end
  end

  context 'with exclusion predicate' do
    let(:predicate) { Function::Predicate::Exclusion.new(attribute,[1,2,3]) }

    it 'should return filter literal' do
      should == { :not => { :terms => { :id => [1,2,3] } } }
    end
  end

  context 'with greater than predicate' do
    let(:predicate) { Function::Predicate::GreaterThan.new(attribute,1) }

    it 'should return filter literal' do
      should == { :range => { :id => { :gt => 1 } } }
    end
  end

  context 'with greater than or equal to predicate' do
    let(:predicate) { Function::Predicate::GreaterThanOrEqualTo.new(attribute,1) }

    it 'should return filter literal' do
      should == { :range => { :id => { :gte => 1 } } } 
    end
  end

  context 'with less than predicate' do
    let(:predicate) { Function::Predicate::LessThan.new(attribute,1) }

    it 'should return filter literal' do
      should == { :range => { :id => { :lt => 1 } } }
    end
  end

  context 'with less than or equal to predicate' do
    let(:predicate) { Function::Predicate::LessThanOrEqualTo.new(attribute,1) }

    it 'should return filter literal' do
      should == { :range => { :id => { :lte => 1 } } }
    end
  end
end
