require 'spec_helper'

describe Adapter::Elasticsearch::Connection,'#exist?' do
  let(:object)     { described_class.new(uri) }
  let(:uri)        { 'http://example.com:9200/index' }

  subject { object.exist? }

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

  context 'when index does exist' do
    let(:request) do
      [:head,"/index",[200,{},'']]
    end

    it 'should execute requests' do
      subject
      adapter.verify_stubbed_calls
    end

    it { should be(true) }
  end

  context 'when index does NOT exist' do
    let(:request) do
      [:head,"/index",[404,{},'']]
    end

    it 'should execute requests' do
      subject
      adapter.verify_stubbed_calls
    end

    it { should be(false) }
  end
end
