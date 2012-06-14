require 'spec_helper'

describe Adapter::Elasticsearch::Preprocessor::Response,'#run' do
  let(:object) { described_class.new(env) }

  subject { object.run }

  let(:env) do
    {
      :logger => logger,
      :method => method,
      :request => options,
      :status => status,
      :response_headers => response_headers,
      :body => body
    }
  end

  let(:options) { {} }

  let(:body) { '{"foo":"bar"}' }
  let(:method) { :get }

  let(:logger) { nil }

  let(:status) { 200 }
  let(:response_headers) { { 'content_type' => content_type } }
  let(:content_type) { 'application/json; charset=UTF-8' }

  it_should_behave_like 'a command method'

  context 'when body should be converted from json' do
    before do
      options[:convert_json]=true
    end

    context 'and content type is json' do
      it 'should convert body from json' do
        subject
        env[:body].should == { 'foo' => 'bar' }
      end
    end

    context 'and content type is NOT json' do
      let(:content_type) { 'text/plain' }

      it 'should raise error' do
        expect { subject }.to raise_error(RuntimeError,'Expected json content type but got: text/plain')
      end
    end
  end

  context 'when many status codes are expected' do
    before do
      options[:expect_status] = [200,400]
    end

    context 'and status code NOT matches an expected status' do
      let(:body)   { 'error' }
      let(:status) { 201 }

      it 'should raise error' do
        expect { subject }.to raise_error(RuntimeError,'Remote error: error')
      end
    end

    context 'and status code matches expected status' do
      it 'should not raise exception' do
        subject
      end
    end
  end

  context 'when single status code was expected' do
    before do
      options[:expect_status] = 200
    end

    context 'and status code NOT matches expected status' do
      let(:body)   { 'error' }
      let(:status) { 201 }

      it 'should raise error' do
        expect { subject }.to raise_error(RuntimeError,'Remote error: error')
      end
    end

    context 'and status code matches expected status' do
      it 'should not raise exception' do
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

