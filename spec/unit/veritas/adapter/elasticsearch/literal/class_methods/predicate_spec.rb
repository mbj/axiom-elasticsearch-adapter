require 'spec_helper'

describe Adapter::Elasticsearch::Literal, '.predicate' do
  let(:object) { Adapter::Elasticsearch::Literal }

  subject { object.send(:predicate,input) }

  context 'with unsupported predicate' do
    let(:input) { Object.new }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError,"Unsupported predicate: Object")
    end
  end
end
