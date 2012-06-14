require 'spec_helper'

describe Adapter::Elasticsearch::Connection,'#refresh' do
  let(:object)     { described_class.new(uri) }
  let(:uri)        { 'http://example.com:9200/index' }

  subject { object.refresh }

  let(:adapter) do 
    Faraday::Adapter::Test::Stubs.new do |stub|
      method,path,result = request
      stub.send(method,path) do
        result
      end
    end
  end

  before do
    object.stub(:adapter => [:test,adapter])
  end

  let(:request) do
    [:post,"/index/_refresh",[200,{},'']]
  end

  it 'should execute requests' do
    subject
    adapter.verify_stubbed_calls
  end

  it_should_behave_like 'a command method'
end
