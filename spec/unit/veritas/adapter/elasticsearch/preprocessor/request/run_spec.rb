require 'spec_helper'

describe Adapter::Elasticsearch::Preprocessor::Request,'#run' do
  let(:object) { described_class.new(env) }

  subject { object.run }

  let(:logger) { nil }

  let(:env) do
    {
      :logger => logger,
      :url => "http://example.com/index/_search",
      :method => :get,
      :body => { :foo => :bar }
    }
  end

  it_should_behave_like 'a command method'

  it 'should convert body to json' do
    subject
    env[:body].should == '{"foo":"bar"}'
  end

  context 'with logger present' do
    let(:logger) { mock }

    it 'should log request' do
      logger.should_receive(:debug).with('GET http://example.com/index/_search {"foo":"bar"}')
      subject
    end
  end
end

