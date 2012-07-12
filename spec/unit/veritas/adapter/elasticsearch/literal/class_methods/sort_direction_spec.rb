require 'spec_helper'

# This method is private and this spec only exists to get coverage
# for branch that must be present but will never be executed.
describe Adapter::Elasticsearch::Literal, '.sort_direction' do
  let(:object) { Adapter::Elasticsearch::Literal }

  subject { object.send(:sort_direction,input) }

  context 'with unsupported operation' do
    let(:input) { Object.new }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError,"Unsupported operation: Object")
    end
  end
end
