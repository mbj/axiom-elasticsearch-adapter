require 'spec_helper'

describe Adapter::Elasticsearch::Query::Unlimited,'#bounds' do
  subject { object.send(:bounds) }

  let(:object)      { described_class.new(driver,relation) }
  let(:relation)    { mock('Relation')                     }
  let(:driver)      { mock('Driver', :slice_size => 2**30) }

  let(:slice_size) do
     object.send(:slice_size)
  end

  it { should be_kind_of(Enumerator) }

  it 'should return step enumerator from 0 to max integer with step of slice size' do
    subject.to_a.should == [
      [0, 2**30],
      [2**30, 2**30],
    ]
  end
end
