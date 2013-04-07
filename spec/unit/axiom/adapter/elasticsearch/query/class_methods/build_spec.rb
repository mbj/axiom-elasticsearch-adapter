require 'spec_helper'

describe Adapter::Elasticsearch::Query,'.build' do
  subject { object.build(driver,relation) }

  let(:relation) { mock('Relation') }
  let(:driver)   { mock('Driver')   }
  let(:visitor)  { mock('Visitor',:limited? => limited) }
  let(:object)   { described_class }

  before do
    Adapter::Elasticsearch::Visitor.stub(:new => visitor)
  end

  let(:limited) { true }

  it 'should initialize visitor with relation' do
    Adapter::Elasticsearch::Visitor.should_receive(:new).with(relation, driver)
    subject
  end

  context 'when relation is limited' do
    it 'should initialize Query::Limited with visitor' do
      Adapter::Elasticsearch::Query::Limited.should_receive(:new).with(visitor)
      subject
    end

    it 'should return a Query::Limited instance' do
      should be_kind_of(Adapter::Elasticsearch::Query::Limited)
    end
  end

  context 'when relation is NOT limited' do
    let(:limited) { false }

    it 'should initialize Query::Unlimited with visitor' do
      Adapter::Elasticsearch::Query::Unlimited.should_receive(:new).with(visitor)
      subject
    end

    it 'should return a Query::Unlimited instance' do
      should be_kind_of(Adapter::Elasticsearch::Query::Unlimited)
    end
  end
end
