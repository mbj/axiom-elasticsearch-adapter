require 'spec_helper'

describe Adapter::Elasticsearch::QueryBuilder,'#fields' do
  let(:object) { described_class.new(mock) }

  # #fields is a private method. The raise statement cannot be easily triggered from outside.
  subject { object.send(:fields) }

  it 'should raise error' do
    expect { subject }.to raise_error(RuntimeError,"no fields")
  end
end
