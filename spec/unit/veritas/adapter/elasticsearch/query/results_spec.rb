require 'spec_helper'

describe Adapter::Elasticsearch::Query,'#results' do
  subject { object.send(:results) }

  let(:object)   { described_class.new(driver,relation) }
  let(:relation) { mock('Relation') }
  let(:driver)   { mock('Driver') }

  it 'should raise error' do
    expect { subject }.to raise_error(NotImplementedError,'Veritas::Adapter::Elasticsearch::Query#results must be implemented')
  end
end
