require 'spec_helper'

describe Adapter::Elasticsearch::Gateway,'#replace' do
  let(:operation) { :replace }

  it_should_behave_like 'a method forwarded to relation'
end
