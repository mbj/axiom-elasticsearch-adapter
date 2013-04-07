shared_examples_for 'a query #each method' do
  subject { object.each { |tuple| yields << tuple } }

  let(:object)     { described_class.new(driver,visitor) }
  let(:components) { { :size => limit } }
  let(:visitor)    { Adapter::Elasticsearch::Visitor.new(relation) }
  let(:driver)     { mock('Driver',:slice_size => slice_size)   }
  let(:tuple)      { [ 1 ]            }
  let(:document)   { { "id" => 1 }    }
  let(:header)     { mock('Header')   }
  let(:yields)     { [] }

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

  class FakeType
    def initialize(expected_reads)
      @expected_reads = expected_reads.dup
      freeze
    end

    def search(query)
      expected_query, documents = @expected_reads.slice!(0)
      query.should == expected_query
      FakeResult.new(documents)
    end
  end

  it_should_behave_like 'a command method'

  context 'with no block' do
    subject { object.each }

    it { should be_instance_of(to_enum.class) }

    it 'yield the expected values' do
      subject.to_a.should eql(expected_tuples)
    end
  end

  it 'yields each tuple' do
    expect { subject }.to change { yields.dup }.
      from([]).
      to(expected_tuples)
  end

  let(:expected_tuples) do
    expected_reads.each_with_object([]) do |expectation, accumulator|
      _,documents = expectation
      tuples = documents.map { |document| document.values_at('id') }
      accumulator.concat(tuples)
    end
  end
end
