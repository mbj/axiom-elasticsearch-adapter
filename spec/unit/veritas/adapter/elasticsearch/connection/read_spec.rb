require 'spec_helper'

# This is a pice of mocked shit. But im unable to inject the faraday test adapter nicely.
describe Adapter::Elasticsearch::Connection,'#read' do
  let(:object)     { described_class.new(uri,logger) }
  let(:uri)        { 'http://example.com:9200/index' }
  let(:data)       { { 'a' => 'b' } }
  let(:query)      { { 'foo' => 'bar' } }
  let(:type)       { 'type' }
  let(:logger)     { nil }

  subject { object.read(type,query) }

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

  context 'with successful read' do
    let(:request) do
      [:get,'/index/type/_search', [200,{'content_type' => 'application/json; charset=UTF-8'}, JSON.dump(data)]]
    end

    it 'should return data' do
      should == data
    end

    context 'when logger is present' do
      let(:logger) { mock }

      it 'should log' do
        logger.should_receive(:debug).with("GET http://example.com:9200/index/type/_search #{JSON.dump(query)}")
        logger.should_receive(:debug).with("200 ab")
        subject
      end
    end
  end

  context 'with unsuccessful read' do
    let(:request) do
      [:get,'/index/type/_search', [500,{'content_type' => 'text/html; charset=UTF-8'}, "error"]]
    end

    it 'should raise error' do
      expect { subject }.to raise_error(RuntimeError,'Remote error: error')
    end
  end
end
