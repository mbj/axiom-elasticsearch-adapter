require 'spec_helper'

describe Adapter::Elasticsearch::Connection,'#logger' do
  let(:object) { described_class.new(mock,logger) }

  let(:logger) { mock }

  subject { object.logger }

  it 'should return logger' do
    should be(logger)
  end
end
