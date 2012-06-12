#require 'spec_helper'
#
#describe Adapter::Elasticsearch,'#read' do
#  let(:object) { described_class.new(uri) }
#
#  let(:uri)    { mock }
#
#  subject { object.read(relation) }
#
#  let(:header) do
#    [
#      [ :firstname, String ],
#      [ :lastname, String ]
#    ]
#  end
#
#  context 'with a base relation' do
#    let(:relation) { Veritas::Relation::Base.new(:users,header) }
#
#    its(:to_a) { should eql([]) }
#  end
#
#  context 'with a restriction relation' do
#    let(:relation) { Veritas::Relation::Base.new(:users,header).restrict { |r| r.firstname.eq('Markus') } }
#
#    its(:to_a) { should eql([]) }
#  end
#end
