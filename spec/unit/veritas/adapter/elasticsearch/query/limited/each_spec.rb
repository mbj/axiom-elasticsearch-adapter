require 'spec_helper'

describe Adapter::Elasticsearch::Query::Limited,'#each' do
  let(:relation)   { Relation::Base.new('name',[[:id,Integer]]).sort_by { |r| [r.id.desc] }.take(limit) }

  let(:slice_length) { 3 }

  context 'when limit is greather than slice size' do
    let(:limit)        { 4 }

    context 'and result count is less than slice size' do
      let(:expected_reads) do
        [ 
          [ 
            visitor.path, 
            { :from => 0,:size => 3, :sort => [:id => { :order => :desc } ], :fields => [:id] },
            [ { 'id' => 1 } ]
          ]
        ]
      end

      it_should_behave_like 'a query #each method'
    end

    context 'and result count is equal to slice size' do
      let(:expected_reads) do
        [ 
          [ 
            visitor.path, 
            { :from => 0,:size => 3, :sort => [:id => { :order => :desc } ], :fields => [:id] },
            [ { 'id' => 1 } ] * 3
          ],
          [ 
            visitor.path, 
            { :from => 3,:size => 1, :sort => [:id => { :order => :desc } ], :fields => [:id] },
            []
          ]
        ]
      end

      it_should_behave_like 'a query #each method'
    end

    context 'and result count is greater than slice size' do
      let(:expected_reads) do
        [ 
          [ 
            visitor.path, 
            { :from => 0,:size => 3, :sort => [:id => { :order => :desc } ], :fields => [:id] },
            [ { 'id' => 1 } ] * 3
          ],
          [ 
            visitor.path, 
            { :from => 3,:size => 1, :sort => [:id => { :order => :desc } ], :fields => [:id] },
            [ { 'id' => 1 } ] 
          ]
        ]
      end

      it_should_behave_like 'a query #each method'
    end
  end
  
  context 'when limit is lower than slice size' do
    let(:limit) { 2 }

    let(:expected_reads) do
      [ 
        [ 
          visitor.path, 
          { :from => 0,:size => 2, :sort => [:id => { :order => :desc } ], :fields => [:id] },
          [ { 'id' => 1 } ]
        ],
      ]
    end

    it_should_behave_like 'a query #each method'
  end
end
