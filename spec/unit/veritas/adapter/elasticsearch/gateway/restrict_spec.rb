# encoding: utf-8
require 'spec_helper'

describe Adapter::Elasticsearch::Gateway, '#restrict' do
  subject { object.restrict(args, &block) }

  let(:adapter)   { mock('Adapter')                         }
  let(:operation) { :restrict }
  let(:relation)  { mock('Relation', :restrict => response) }
  let(:response)  { mock('New Relation', :kind_of? => true) }
  let!(:object)   { described_class.new(adapter, relation)  }
  let(:args)      { stub                                    }
  let(:factory)   { Relation::Operation::Limit              }
  let(:block)     { lambda { |context| }                    }

  it_should_behave_like 'a supported unary relation method with block'
end
