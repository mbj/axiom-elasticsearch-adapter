require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.from' do
  let(:object) { Adapter::Elasticsearch::Literal }

  subject { object.from(input) }

  let(:input) { 100 }

  it 'should return from literal' do
    should == { :from => 100 }
  end
end
