require 'spec_helper'

describe Adapter::Elasticsearch,'#uri' do
  let(:object) { described_class.new(uri) }
  let(:uri)    { mock }

  subject { object.uri }

  it { should be(uri) }

  it_should_behave_like 'an idempotent method'
end
