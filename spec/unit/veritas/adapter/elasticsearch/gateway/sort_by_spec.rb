# encoding: utf-8
require 'spec_helper'

describe Adapter::Elasticsearch::Gateway, '#sort_by' do
  let(:operation) { :sort_by }
  let(:factory)   { Relation::Operation::Order }

  it_should_behave_like 'a supported unary relation method with block'
end
