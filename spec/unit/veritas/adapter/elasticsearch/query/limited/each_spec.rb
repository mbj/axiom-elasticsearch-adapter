require 'spec_helper'

describe Adapter::Elasticsearch::Query::Limited, '#each' do

  let(:relation)   { Relation::Base.new('name', [[:id, Integer]]).sort_by { |r| [r.id.desc] }.take(limit) }

  context 'when limit is greather than slice size' do
    let(:limit)        { 200 }

    context 'and result count is less than slice size' do
      let(:expected_reads) do
        [
          [
            { :size => 100, :sort => [:id => { :order => :desc } ], :fields => ['id'], :from => 0 },
            [ { 'id' => 1 } ]
          ],
        ]
      end

      it_should_behave_like 'a query #each method'
    end

    context 'and result count is equal to slice size' do
      let(:expected_reads) do
        [
          [
            { :size => 100, :sort => [:id => { :order => :desc } ], :fields => ['id'], :from => 0 },
            [ { 'id' => 1 } ] * 100
          ],
          [
            { :size => 100, :sort => [:id => { :order => :desc } ], :fields => ['id'], :from => 100 },
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
            { :size => 100, :sort => [:id => { :order => :desc } ], :fields => ['id'], :from => 0 },
            [ { 'id' => 1 } ] * 100
          ],
          [
            { :size => 100, :sort => [:id => { :order => :desc } ], :fields => ['id'], :from => 100 },
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
          { :size => 2, :sort => [:id => { :order => :desc } ], :fields => ['id'], :from => 0 },
          [ { 'id' => 1 } ]
        ],
      ]
    end

    it_should_behave_like 'a query #each method'
  end

end
