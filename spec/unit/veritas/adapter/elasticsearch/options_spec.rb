require 'spec_helper'

describe Adapter::Elasticsearch,'#options' do
  let(:object) { described_class.new(mock,options) }
  let(:options)    { mock }

  subject { object.options }

  it { should be(options) }

  it_should_behave_like 'an idempotent method'
end

