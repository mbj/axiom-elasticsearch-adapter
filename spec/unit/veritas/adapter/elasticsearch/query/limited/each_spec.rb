require 'spec_helper'

describe Adapter::Elasticsearch::Query::Limited,'#each' do
  subject { object.each { |tuple| yields << tuple } }

  let(:object)     { described_class.new(driver,visitor) }
  let(:components) { { :size => limit } }
  let(:relation)   { Relation::Base.new('name',[[:id,Integer]]).sort_by { |r| [r.id.desc] }.take(limit) }
  let(:visitor)    { Adapter::Elasticsearch::Visitor.new(relation) }
  let(:driver)     { mock('Driver')   }
  let(:tuple)      { [ 1 ]            }
  let(:document)   { { "id" => 1 }    }
  let(:header)     { mock('Header')   }
  let(:yields)     { [] }

  let(:slice_length) { 3 }

  let(:limit)      { 10 }

  before do
    object.stub(:slice_size => slice_length)
  end

  class FakeResult
    def initialize(documents)
      @documents = documents
    end

    def each(&block)
      @documents.each(&block) 
    end

    def documents
      @documents
    end

    def size
      @documents.size
    end

    def empty?
      @documents.empty?
    end
  end
  
  it_should_behave_like 'an #each method'

  it 'yields each tuple' do
    expect { subject }.to change { yields.dup }.
      from([]).
      to([ tuple ])
  end

  before do
    driver.stub(:read => FakeResult.new([document]))
  end

  shared_examples_for 'a correct read' do
    it 'should return expected tuples' do
      subject
      yields.should == expected_reads.each_with_object([]) do |expectation,accumulator| 
        accumulator.concat(expectation.last.map(&:values)) 
      end
    end
  end

  context 'with results' do
    let(:slice_length) { 3 }

    before do
      expected_reads.each do |path,query,documents|
        driver.should_receive(:read).with(path,query).and_return(FakeResult.new(documents))
      end
    end

    context 'and slice length is lower than limit' do
      let(:limit)        { 4 }

      context 'and result count is less than slice length' do
        let(:expected_reads) do
          [ 
            [ 
              visitor.path, 
              { :from => 0,:size => slice_length, :sort => [:id => { :order => :desc } ], :fields => [:id] },
              [ { 'id' => 1 } ]
            ]
          ]
        end

        it_should_behave_like 'a correct read'
      end

      context 'and result count is equal to slice length' do
        let(:expected_reads) do
          [ 
            [ 
              visitor.path, 
              { :from => 0,:size => slice_length, :sort => [:id => { :order => :desc } ], :fields => [:id] },
              [ { 'id' => 1 } ] * slice_length
            ],
            [ 
              visitor.path, 
              { :from => slice_length,:size => 1, :sort => [:id => { :order => :desc } ], :fields => [:id] },
              []
            ]
          ]
        end

        it_should_behave_like 'a correct read'
      end

      context 'and result count is greater than slice length' do
        let(:expected_reads) do
          [ 
            [ 
              visitor.path, 
              { :from => 0,:size => slice_length, :sort => [:id => { :order => :desc } ], :fields => [:id] },
              [ { 'id' => 1 } ] * slice_length
            ],
            [ 
              visitor.path, 
              { :from => slice_length,:size => limit - slice_length, :sort => [:id => { :order => :desc } ], :fields => [:id] },
              [ { 'id' => 1 } ] 
            ]
          ]
        end

        it_should_behave_like 'a correct read'
      end
    end
  end
end
