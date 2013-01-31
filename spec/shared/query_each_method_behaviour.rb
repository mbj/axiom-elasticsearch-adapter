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

  it_should_behave_like 'an #each method'

  it 'yields each tuple' do
    expect { subject }.to change { yields.dup }.
      from([]).
      to(expected_tuples)
  end

  let(:expected_tuples) do
    expected_reads.each_with_object([]) do |expectation,accumulator|
      _,_,documents = expectation
      tuples = documents.map { |document| document.values_at('id') }
      accumulator.concat(tuples)
    end
  end

  before do
    description = self.class.description
    read_count =
      case description
      when 'returns instance of Enumerator'
        0
      when 'yields the expected values'
        2
      when 'returns self'
        1
      else
        1
      end

    expected_reads.each do |path,query,documents|
      driver.should_receive(:read).with(path,query).exactly(read_count).times.and_return(FakeResult.new(documents))
    end
  end
end
