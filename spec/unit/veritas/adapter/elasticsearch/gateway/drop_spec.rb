# encoding: utf-8

require 'spec_helper'

describe Adapter::Elasticsearch::Gateway, '#drop' do
  subject { object.drop(args) }

  let(:adapter)   { mock('Adapter')                         }
  let(:relation)  { mock('Relation', :drop => response)     }
  let(:operation) { :drop                                   }
  let(:response)  { mock('New Relation', :kind_of? => true) }
  let!(:object)   { described_class.new(adapter, relation)  }
  let(:args)      { stub                                    }
  let(:factory)   { Relation::Operation::Offset             }

  it_should_behave_like 'a supported unary relation method'
end
