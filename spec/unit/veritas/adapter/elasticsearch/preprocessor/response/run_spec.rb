require 'spec_helper'

describe Adapter::Elasticsearch::Preprocessor::Response,'#run' do
  let(:object) { described_class.new(env) }

  subject { object.run }

  let(:env) do
    {
      :logger => logger,
      :method => method,
      :status => status,
      :response_headers => response_headers,
      :body => body
    }
  end

  let(:body) { '{"foo":"bar"}' }
  let(:method) { :get }

  let(:logger) { nil }

  let(:status) { 200 }
  let(:response_headers) { { 'content_type' => content_type } }
  let(:content_type) { 'application/json; charset=UTF-8' }

  it_should_behave_like 'a command method'

  context 'when content type is application/json' do
    it 'should convert body from json' do
      subject
      env[:body].should == { 'foo' => 'bar' }
    end
  end

  context 'when status is between 400 and 600' do
    let(:body) { 'error' }
    let(:content_type) { 'text/plain' }
    let(:status) { 500 }

    context 'and request method is NOT HEAD' do
      it 'should raise error' do
        expect { subject }.to raise_error(RuntimeError,'Remote error: error')
      end
    end

    context 'and request method is HEAD' do
      let(:method) { :head }

      it 'should not raise' do
        subject
      end
    end
  end

  context 'with logger present' do
    let(:logger) { mock }

    it 'should log response' do
      logger.should_receive(:debug).with('200')
      subject
    end
  end
end

