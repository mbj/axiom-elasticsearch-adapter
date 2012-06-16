require 'spec_helper'

describe Adapter::Elasticsearch::Result,'#each' do
  subject { object.each { |tuple| yields << tuple } }

  let(:object)   { described_class.new(relation,data)         }
  let(:header)   { Relation::Header.new([ [ :id, Integer ] ]) }
  let(:body)     { [ [ 1 ], [ 2 ] ]                           }
  let(:relation) { Relation::Base.new(:name, header, body)    }
  let(:yields)   { []                                         }
  let(:data)     { { 'hits' => { 'hits' => hits } }           }

  it_should_behave_like 'an #each method'

  let(:hits) do 
    [
      { 'fields' => { 'id' => 1 } },
      { 'fields' => { 'id' => 2 } }
    ]
  end

  it 'yields each tuple' do
    expect { subject }.to change { yields.dup }.
      from([]).
      to([ [ 1 ], [ 2 ] ])
  end
end
