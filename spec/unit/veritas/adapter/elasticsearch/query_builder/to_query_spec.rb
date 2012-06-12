require 'spec_helper'

describe Adapter::Elasticsearch::QueryBuilder,'#to_query' do
  let(:object) { described_class.new(relation) } 

  let(:header) do
    [
      [:firstname,String],
      [:lastname,String]
    ]
  end

  let(:base_relation) do
    Veritas::Relation::Base.new(:name,header) 
  end

  subject { object.to_query }

  context 'with an unsupported relation' do
    let(:relation) { base_relation.rename(:firstname => :surname) }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError,"Unsupported relation: #{relation.class}")
    end
  end

  context 'with a base relation' do
    let(:relation) { base_relation }

    it_should_behave_like 'an idempotent method'

    it 'should return correct query' do
      should == [
        [ "name", 
          {
            :size   => 100_000,
            :fields => [:firstname,:lastname],
          }
        ]
      ]
    end
  end

  context 'with equality restriction on base relation' do
    let(:relation) { base_relation.restrict { |r| r.firstname.eq('Markus') } }

    it_should_behave_like 'an idempotent method'

    it 'should return correct query' do
      should == [
        [ "name", 
          {
            :size   => 100_000,
            :fields => [:firstname,:lastname],
            :filter => { :term => { :firstname => 'Markus' } }
          }
        ]
      ]
    end
  end

  context 'with inequality restriction on base relation' do
    let(:relation) { base_relation.restrict { |r| r.firstname.ne('Markus') } }

    it_should_behave_like 'an idempotent method'

    it 'should return correct query' do
      should == [
        [ "name", 
          {
            :size   => 100_000,
            :fields => [:firstname,:lastname],
            :filter => { :not => { :term => { :firstname => 'Markus' } } }
          }
        ]
      ]
    end
  end

  context 'with OR connected restrictions on base relation' do
    let(:relation) { base_relation.restrict { |r| r.firstname.eq('Markus').or(r.lastname.eq('Schirp')) } }

    it_should_behave_like 'an idempotent method'

    it 'should return correct query' do
      should == [
        [ "name", 
          {
            :size   => 100_000,
            :fields => [:firstname,:lastname],
            :filter => { :or => [{ :term => { :firstname => 'Markus' } },{:term => { :lastname => 'Schirp' } }] }
          }
        ]
      ]
    end
  end

  context 'with ordered base relation' do
    let(:ordered_relation) { base_relation.sort_by { |r| [ r.firstname.desc, r.lastname ] } }

    it_should_behave_like 'an idempotent method'

    let(:relation) { ordered_relation }

    it 'should return correct query' do
      should == [
        [ "name", 
          {
            :size   => 100_000,
            :fields => [:firstname,:lastname],
            :sort   => [ { :firstname => { :order => :desc } }, { :lastname => { :order => :asc } } ]
          }
        ]
      ]
    end

    context 'when limiting' do
      let(:relation) { ordered_relation.take(5) }

      it_should_behave_like 'an idempotent method'

      it 'should return correct query' do
        should == [
          [ "name", 
            {
              :fields => [:firstname,:lastname],
              :size   => 5,
              :sort   => [ { :firstname => { :order => :desc } }, { :lastname => { :order => :asc } } ]
            }
          ]
        ]
      end
    end

    context 'when skipping' do
      let(:relation) { ordered_relation.drop(5) }

      it_should_behave_like 'an idempotent method'

      it 'should return correct query' do
        should == [
          [ "name", 
            {
              :size   => 100_000,
              :fields => [:firstname,:lastname],
              :from   => 5,
              :sort   => [ { :firstname => { :order => :desc } }, { :lastname => { :order => :asc } } ]
            }
          ]
        ]
      end
    end
  end
end
