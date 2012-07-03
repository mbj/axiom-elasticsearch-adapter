require 'spec_helper'

describe Adapter::Elasticsearch::Query::Unlimited,'#each' do
  let(:relation)     { Relation::Base.new('name',[[:id,Integer]]) }
  let(:slice_size) { 3 }

  context 'when result count is lower than slice length' do
    let(:expected_reads) do
      [ 
        [ 
          visitor.path, 
          { :from => 0,:size => 3, :fields => ['id'] },
          [ { 'id' => 1 } ]
        ]
      ]
    end

    it_should_behave_like 'a query #each method'
  end

  context 'when result count is equal to slice length' do
    let(:expected_reads) do
      [ 
        [ 
          visitor.path, 
          { :from => 0,:size => 3, :fields => ['id'] },
          [ { 'id' => 1 } ] * 3
        ],
        [ 
          visitor.path, 
          { :from => 3,:size => 3, :fields => ['id'] },
          [ { 'id' => 1 } ] 
        ]
      ]
    end

    it_should_behave_like 'a query #each method'
  end

  context 'when result count greater than slice length' do
    let(:expected_reads) do
      [ 
        [ 
          visitor.path, 
          { :from => 0,:size => 3, :fields => ['id'] },
          [ { 'id' => 1 } ] * 3
        ],
        [ 
          visitor.path, 
          { :from => 3,:size => 3, :fields => ['id'] },
          [ { 'id' => 1 } ] * 2
        ]
      ]
    end

    it_should_behave_like 'a query #each method'
  end
end
