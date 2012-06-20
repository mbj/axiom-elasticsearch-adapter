# encoding: utf-8

shared_examples_for 'a supported unary relation method' do
  let(:adapter)   { mock('Adapter')                         }
  let(:relation)  { mock('Relation', operation => response) }
  let(:response)  { mock('New Relation',:kind_of? => true)  }
  let!(:object)   { described_class.new(adapter, relation)  }

  let(:args)    { stub }
  let(:gateway) { mock('New Gateway') }

  subject { object.public_send(operation,args) }

  before do
    described_class.stub!(:new).and_return(gateway)
  end

  it { should equal(gateway) }

  it 'forwards the arguments to relation' do
    relation.should_receive(operation).with(args)
    subject
  end

  it 'initializes the new gateway with the adapter and response' do
    described_class.should_receive(:new).with(adapter, response)
    subject
  end
end

shared_examples_for 'a supported unary relation method with block' do
  it_should_behave_like 'a supported unary relation method'
end
