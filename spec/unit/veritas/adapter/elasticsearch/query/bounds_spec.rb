require 'spec_helper'

describe Adapter::Elasticsearch::Query,'#bounds' do
  subject { object.send(:bounds) }

  let(:object)      { described_class.new(driver,relation) }
  let(:relation)    { mock('Relation')                     }
  let(:driver)      { mock('Driver')                       }

  it 'should raise error' do
    expect { subject }.to raise_error(NotImplementedError,'Veritas::Adapter::Elasticsearch::Query#bounds must be implemented')
  end
end
