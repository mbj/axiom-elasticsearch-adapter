require 'spec_helper'

describe Adapter::Elasticsearch::Query::Unlimited, '#bounds' do
  subject { object.send(:bounds) }

  let(:object)      { described_class.new(relation)        }
  let(:relation)    { mock('Relation')                     }
  let(:driver)      { mock('Driver', :slice_size => 2**30) }

  let(:slice_size) do
    100
  end

  it { should be_kind_of(Enumerator) }

  it 'should return step enumerator from 0 to max integer with step of slice size' do
    subject.next.should == [0 * slice_size, slice_size]
    subject.next.should == [1 * slice_size, slice_size]
    subject.next.should == [2 * slice_size, slice_size]
  end
end
