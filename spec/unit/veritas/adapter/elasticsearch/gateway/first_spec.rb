# encoding: utf-8

require 'spec_helper'

describe Adapter::Elasticsearch::Gateway, '#first' do
  let(:operation) { :first }

  let(:factory)   { Relation::Operation::Limit }
  let(:arguments) { [] }

  it_should_behave_like 'a supported unary relation method'
end
