require 'spec_helper'

describe Adapter::Elasticsearch::Query,'#each' do
  subject { object.each { |tuple| yields << tuple } }

  let(:object)  { described_class.new(driver,visitor) }
  let(:visitor) { mock('Visitor',:components => { :fields => [:id] }) }
  let(:driver)  { mock('Driver') }
  let(:results) { [mock('Result',:documents => [document])] }
  let(:document) { { 'id' => 1 } }
  let(:yields)  { [] }

  before do
    object.stub(:results => results)
  end
  
  it_should_behave_like 'an #each method'

  it 'yields each tuple' do
    expect { subject }.to change { yields.dup }.
      from([]).
      to([[1]])
  end
end
