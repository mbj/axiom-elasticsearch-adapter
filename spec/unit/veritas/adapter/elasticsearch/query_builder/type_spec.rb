require 'spec_helper'

describe Adapter::Elasticsearch::QueryBuilder,'#type' do
  let(:object) { described_class.new(mock) }

  # #type is a private method. The raise statement cannot be easily triggered from outside.
  subject { object.send(:type) }

  it 'should raise error' do
    expect { subject }.to raise_error(RuntimeError,"no type")
  end
end
