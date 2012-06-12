require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.size' do
  let(:object) { Adapter::Elasticsearch::Literal }

  subject { object.size(input) }

  let(:input) { 100 }

  it 'should return size literal' do
    should == { :size => 100 }
  end
end
