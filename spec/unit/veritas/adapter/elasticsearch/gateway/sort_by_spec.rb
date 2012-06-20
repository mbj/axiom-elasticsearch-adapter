# encoding: utf-8
require 'spec_helper'

describe Adapter::Elasticsearch::Gateway, '#sort_by' do
  subject { object.sort_by(args, &block) }

  let(:adapter)   { mock('Adapter')                         }
  let(:relation)  { mock('Relation', :sort_by => response)  }
  let(:operation) { :sort_by                                }
  let(:response)  { mock('New Relation', :kind_of? => true) }
  let!(:object)   { described_class.new(adapter, relation)  }
  let(:args)      { stub                                    }
  let(:block)     { lambda { |context| }                    }

  it_should_behave_like 'a supported unary relation method with block'
end
