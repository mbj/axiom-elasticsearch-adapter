require 'spec_helper'

describe Adapter::Elasticsearch::Driver,'#drop' do
  let(:object)     { described_class.new(uri,options) }
  let(:name)       { 'test' }
  let(:uri)        { 'http://example.com:9200' }

  let(:options) { { :adapter => [:test,adapter] } }

  subject { object.drop(name) }

  let(:adapter) do 
    Faraday::Adapter::Test::Stubs.new do |stubs|
      requests.each do |method,path,result|
        stubs.send(method,path) do
          result
        end
      end
    end
  end

  before do
    object.stub(:exist? => exist)
  end

  context 'when index does exist' do
    let(:exist) { true }

    let(:requests) do
      [
        [:delete,'/test',[status,{'content-type' => 'application/json; charset=UTF-8'},'{}']]
      ]
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
        expect { subject }.to raise_error(RuntimeError,'Remote error: {}')
      end
    end
  end

  context 'when index does not exists' do
    let(:exist) { false }

    let(:requests) { [] }

    it 'should execute requests' do
      subject
      adapter.verify_stubbed_calls
    end

    it_should_behave_like 'a command method'
  end
end
