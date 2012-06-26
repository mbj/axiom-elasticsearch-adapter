require 'spec_helper'

describe Adapter::Elasticsearch::NullLogger,'#debug' do
  let(:method) { :debug }

  it_should_behave_like 'a null logger method'
end
