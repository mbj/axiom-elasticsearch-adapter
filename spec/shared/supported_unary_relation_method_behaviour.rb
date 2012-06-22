# encoding: utf-8

shared_examples_for 'a supported unary relation method' do
  subject { object.public_send(operation,args,&block) }

  let(:adapter)   { mock('Adapter')                         }
  let(:relation)  { mock('Relation', operation => response) }
  let(:response)  { mock('New Relation',:kind_of? => true, :class => factory)  }
  let!(:object)   { described_class.new(adapter, relation)  }

  let(:args)    { stub }
  let(:gateway) { mock('New Gateway') }

  unless instance_methods.map(&:to_s).include?('block')
    let(:block) { nil }
  end

  before do
    described_class.stub!(:new).and_return(gateway)
  end

  it { should equal(gateway) }

  it 'forwardst the arguemnts to relation' do
    relation.should_receive(operation).with(args).and_return(response)
    subject
  end

  it 'forwards the block to relation' do
    relation.stub!(operation) { |_args, proc| proc.should equal(block) }
    subject
  end

  it 'initializes the new gateway with the adapter and response' do
    described_class.should_receive(:new).with(adapter, response, [factory].to_set)
    subject
  end
end

shared_examples_for 'a supported unary relation method with block' do
  it_should_behave_like 'a supported unary relation method'

  let(:block) { lambda { |context| } }
end
