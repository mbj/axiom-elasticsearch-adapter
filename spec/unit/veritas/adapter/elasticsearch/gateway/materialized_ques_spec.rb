require 'spec_helper'

describe Adapter::Elasticsearch::Gateway,'#materialized?' do
  let(:operation) { :materialized? }

  it_should_behave_like 'a method forwarded to relation'
end
