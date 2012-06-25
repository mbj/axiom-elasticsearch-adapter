require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.from' do
  subject { object.from(operation) }

  let(:object)    { Adapter::Elasticsearch::Literal   }
  let(:operation) { mock('Operation',:offset => 100 ) }

  it 'should return from literal' do
    should == 100
  end
end
