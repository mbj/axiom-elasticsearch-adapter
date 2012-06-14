require 'spec_helper'

describe Adapter::Elasticsearch::Connection,'#refresh' do
  let(:object)     { described_class.new(uri,options) }
  let(:uri)        { 'http://example.com:9200/index' }

  subject { object.refresh }

  let(:options)    { { :adapter => [:test,adapter] } }

  let(:adapter) do 
    Faraday::Adapter::Test::Stubs.new do |stub|
      method,path,result = request
      stub.send(method,path) do
        result
      end
    end
  end

  let(:request) do
    [:post,"/index/_refresh",[status,{},'body']]
  end

  context 'and request is successful' do
    let(:status) { 200 }

    it 'should execute requests' do
      subject
      adapter.verify_stubbed_calls
    end

    it_should_behave_like 'a command method'
  end

  context 'and request is NOT successful' do
    let(:status) { 500 }

    it 'should raise error' do
      expect { subject }.to raise_error(RuntimeError,'Remote error: body')
    end
  end
end
