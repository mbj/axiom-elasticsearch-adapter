require 'spec_helper'

describe Adapter::Elasticsearch::Visitor,'limited?' do
  subject { object.limited? }

  let(:object)        { described_class.new(relation)             }

  let(:base_relation) { Relation::Base.new(:name,[[:id,Integer]]) }
  let(:sort_relation) { base_relation.sort_by { |r| [r.id.asc] }  }

  context 'when relation is limited' do
    let(:relation) { sort_relation.take(5) }

    it { should be(true) }
  end

  context 'when relation is NOT limited' do
    let(:relation) { sort_relation }

    it { should be(false) }
  end
end
