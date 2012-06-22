# encoding: utf-8
require 'spec_helper'

describe Adapter::Elasticsearch::Gateway, '#restrict' do
  let(:operation) { :restrict }
  let(:factory)   { Algebra::Restriction }

  it_should_behave_like 'a supported unary relation method with block'
end
