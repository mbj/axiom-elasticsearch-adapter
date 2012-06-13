require 'spec_helper'

describe Adapter::Elasticsearch::Literal, '.function' do
  let(:object) { Adapter::Elasticsearch::Literal }

  subject { object.send(:function,input) }

  context 'with unsupported predicate' do
    let(:input) { Object.new }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError,"Unsupported function: Object")
    end
  end
end
