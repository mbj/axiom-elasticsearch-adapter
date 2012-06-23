require 'spec_helper'

describe Adapter::Elasticsearch::Gateway,'#==' do
  let(:operation) { :== }

  it_should_behave_like 'a method forwarded to relation'
end
