# encoding: utf-8
require 'spec_helper'

describe Adapter::Elasticsearch::Gateway, '#take' do
  let(:operation) { :take }

  it_should_behave_like 'a supported unary relation method'
end
