require 'spec_helper'

describe Veritas::Adapter::Elasticsearch::Support,'.lazy_map' do
  subject { object.lazy_map(enumerable,&block) }

  let(:object) { Veritas::Adapter::Elasticsearch::Support }

  context 'without block' do
    let(:block)      { nil }
    let(:enumerable) { mock('Enumerable') }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError,'required block not given')
    end
  end


  context 'with block' do
    let(:enumerable) do
      Object.new.tap do |object|
        def object.each
          yield 1
          yield 2
          raise 'im so lazy'
        end
      end
    end

    let(:block) do
      lambda { |value| value**2 }
    end

    it 'should lazy evaluate block' do
      enum = subject
      enum.take(2).should == [1,4]
      expect { enum.to_a }.to raise_error(RuntimeError,'im so lazy')
    end
  end
end
