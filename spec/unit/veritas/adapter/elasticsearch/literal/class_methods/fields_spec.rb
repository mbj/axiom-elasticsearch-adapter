require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.fields' do
  let(:object) { Adapter::Elasticsearch::Literal }

  subject { object.fields(input) }

  let(:input) { Veritas::Relation::Header.new([[:foo,String],[:bar,String]]) }

  it 'should return fiels literal' do
    should == [:foo,:bar] 
  end
end
