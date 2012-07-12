require 'spec_helper'

describe Adapter::Elasticsearch::Literal, '.sort' do
  let(:object) { Adapter::Elasticsearch::Literal }

  let(:header) do
    [
      [ :id, Integer ],
    ]
  end

  subject { object.sort(input) }


  context 'when sorting asc' do
    let(:input) { Relation.new(header, []).sort_by { |r| [r.id.asc] } }

    it 'should return sort literal' do
      should == [{:id => { :order => :asc } }]
    end
  end

  context 'when sorting desc' do
    let(:input) { Relation.new(header, []).sort_by { |r| [r.id.desc] } }

    it 'should return sort literal' do
      should == [{:id => { :order => :desc } }]
    end
  end
end
