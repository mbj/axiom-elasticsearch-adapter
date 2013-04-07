require 'axiom'
require 'concord'
require 'elasticsearch'
require 'axiom/adapter/elasticsearch/operations'
require 'axiom/adapter/elasticsearch/literal'
require 'axiom/adapter/elasticsearch/visitor'
require 'axiom/adapter/elasticsearch/query'
require 'axiom/adapter/elasticsearch/query/limited'
require 'axiom/adapter/elasticsearch/query/unlimited'
require 'axiom/adapter/elasticsearch/gateway'
require 'axiom/adapter/elasticsearch/adapter'

# jRuby specific overrides.
require 'axiom/adapter/elasticsearch/jruby'

module Axiom
  module Adapter
    # An adapter for elasticsearch
    module Elasticsearch
      include Adamantium

      # Error raised when query on unsupported algebra is created
      class UnsupportedAlgebraError < StandardError; end

      # Error raised when elasticsearch http protocol is violated
      class ProtocolError < StandardError; end

      # Error raised when elasticsearch reports error
      class RemoteError < StandardError; end
    end
  end
end
