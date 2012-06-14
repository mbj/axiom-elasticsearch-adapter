require 'spec_helper'

describe Adapter::Elasticsearch::Preprocessor::Request,'#run' do
  let(:object) { described_class.new(env) }

  subject { object.run }

  let(:logger) { nil }
  
  let(:body) { { :foo => :bar } }

  let(:env) do
    {
      :logger => logger,
      :url => "http://example.com/index/_search",
      :method => :get,
      :body => body,
      :request => options
    }
  end

  let(:options) { {} }

  it_should_behave_like 'a command method'

  context 'when body conversion to json was requested' do
    before do
      options[:convert_json] = true
    end

    it 'should convert body to json' do
      subject
      env[:body].should == '{"foo":"bar"}'
    end
  end

  context 'when body conversion to json was NOT requested' do
    it 'should NOT convert body to json' do
      subject
      env[:body].should == body
    end
  end

  context 'with logger present' do
    let(:logger) { mock }

    it 'should log request' do
      logger.should_receive(:debug).with("GET http://example.com/index/_search #{body.inspect}")
      subject
    end
  end
end

