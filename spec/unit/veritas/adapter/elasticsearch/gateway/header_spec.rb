require 'spec_helper'

describe Adapter::Elasticsearch::Gateway, '#header' do
  subject { object.header }

  let(:object)   { described_class.new(adapter,relation) }
  let(:relation) { mock('Relation', :header => header) }
  let(:header)   { mock('Header') }
  let(:adapter)  { mock('Adapter') }

  it 'should return wrapped relations header' do
    should be(header)
  end
end
