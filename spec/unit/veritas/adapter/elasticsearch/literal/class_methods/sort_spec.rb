require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.sort' do
  let(:object) { Adapter::Elasticsearch::Literal }

  let(:header) do
    [
      [ :id, Integer ],
    ]
  end

  subject { object.sort(input) }

  let(:input) { Relation.new(header,[]).sort_by { |r| [r.id.asc] } }

  it 'should return sort literal' do
    should == { :sort => [{:id => { :order => :asc } }]}
  end
end
