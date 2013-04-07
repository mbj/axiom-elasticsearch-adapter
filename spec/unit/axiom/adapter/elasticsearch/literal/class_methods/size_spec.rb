require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.size' do
  subject { object.size(operation) }

  let(:object)    { Adapter::Elasticsearch::Literal  }
  let(:operation) { mock('Operation', :limit => 100) }

  it 'should return size literal' do
    should == 100
  end
end
