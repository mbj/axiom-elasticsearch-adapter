# encoding: utf-8

require 'spec_helper'

describe Adapter::Elasticsearch::Gateway, '#drop' do
  let(:operation) { :drop }
  let(:factory) { Relation::Operation::Offset }

  it_should_behave_like 'a supported unary relation method'
end
