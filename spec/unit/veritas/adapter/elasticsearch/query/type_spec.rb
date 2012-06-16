require 'spec_helper'

describe Adapter::Elasticsearch::Query,'#base_name' do
  let(:object) { described_class.new(mock) }

  # #type is a private method. The raise statement cannot be easily triggered from outside.
  subject { object.send(:base_name) }

  it 'should raise error' do
    expect { subject }.to raise_error(RuntimeError,'no base name was visited')
  end
end
