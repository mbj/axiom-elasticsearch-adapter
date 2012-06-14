require 'spec_helper' 

describe Adapter::Elasticsearch::Middleware,'#call' do
  let(:object) { described_class.new(*arguments) }

  let(:app)    { mock(:App) }
  let(:env)    { {} }

  let(:arguments) { [app] }

  subject { object.call(env) }

  before do
    Adapter::Elasticsearch::Preprocessor::Request.should_receive(:run).with(env)
    Adapter::Elasticsearch::Preprocessor::Response.should_receive(:run).with(env)
    app.should_receive(:call).with(env).and_return(app)
    app.should_receive(:on_complete).and_yield
  end

  it 'should call request and response preprocessor' do
    subject
  end

  context 'when logger is NOT present in arguments' do
    it 'should NOT store logger in env' do
      subject
      env.should == {}
    end
  end

  context 'when logger is present in arguments' do
    let(:logger) { mock(:Logger) }
    let(:arguments) { [app,logger] }

    it 'should store logger in env' do
      subject
      env.should == { :logger => logger }
    end
  end
end
