require 'spec_helper'

describe Adapter::Elasticsearch::NullLogger,'#warn' do
  let(:method) { :warn }

  it_should_behave_like 'a null logger method'
end
