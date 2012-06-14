require 'spec_helper'

describe Adapter::Elasticsearch::Connection,'#adapter' do
  let(:object) { described_class.new(mock) }

  subject { object.send(:adapter) }
  
  it 'should return net/http adapter' do
    should == [:net_http]
  end
end
