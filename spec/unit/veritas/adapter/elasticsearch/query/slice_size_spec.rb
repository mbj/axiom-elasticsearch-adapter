require 'spec_helper'

# See comment in Query#slice_size in case of objections
describe Adapter::Elasticsearch::Query, '#slice_size' do
  subject { object.send(:slice_size) }

  let(:object) { described_class.new(driver, relation) }

  let(:driver)     { mock('Driver', :slice_size => slice_size) }
  let(:relation)   { mock('Relation') }
  let(:slice_size) { mock('Slice Size') }

  it { should be(slice_size) }

  it_should_behave_like 'an idempotent method'
end
