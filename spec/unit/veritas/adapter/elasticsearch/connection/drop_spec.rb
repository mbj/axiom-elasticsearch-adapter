require 'spec_helper'

describe Adapter::Elasticsearch::Connection,'#drop' do
  let(:object)     { described_class.new(uri) }
  let(:uri)        { 'http://example.com:9200/index' }

  subject { object.drop }

  let(:adapter) do 
    Faraday::Adapter::Test::Stubs.new do |stub|
      requests.each do |method,path,result|
        stub.send(method,path) do
          result
        end
      end
    end
  end

  before do
    object.stub(:adapter => [:test,adapter])
  end

  context 'when index does exist' do
    let(:requests) do
      [
        [:head,"/index",[200,{},'']],
        [:delete,"/index",[200,{},'']]
      ]
    end

    it 'should execute requests' do
      subject
      adapter.verify_stubbed_calls
    end

    it_should_behave_like 'a command method'
  end

  context 'when indec does not exists' do
    let(:requests) do
      [
        [:head,"/index",[200,{},'']],
        [:delete,"/index",[200,{},'']]
      ]
    end

    it 'should execute requests' do
      subject
      adapter.verify_stubbed_calls
    end

    it_should_behave_like 'a command method'
  end
end
