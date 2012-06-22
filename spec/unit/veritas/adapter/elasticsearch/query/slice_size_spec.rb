require 'spec_helper'

# See comment in Query#slice_size in case of objections
describe Adapter::Elasticsearch::Query,'#slice_size' do
  subject { object.send(:slice_size) }
  let(:object) { described_class.new(mock,mock) }

  it { should be(100) }
end
