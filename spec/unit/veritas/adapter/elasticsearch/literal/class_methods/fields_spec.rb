require 'spec_helper'

describe Adapter::Elasticsearch::Literal,'.fields' do
  let(:object) { Adapter::Elasticsearch::Literal }

  subject { object.fields(input) }

  let(:input) { [:foo,:bar] }

  it 'should return fiels literal' do
    should == { :fields => [:foo,:bar] }
  end
end
