require 'veritas'
require 'elasticsearch'
require 'veritas/adapter/elasticsearch/operations'
require 'veritas/adapter/elasticsearch/literal'
require 'veritas/adapter/elasticsearch/visitor'
require 'veritas/adapter/elasticsearch/query'
require 'veritas/adapter/elasticsearch/query/limited'
require 'veritas/adapter/elasticsearch/query/unlimited'
require 'veritas/adapter/elasticsearch/gateway'
require 'veritas/adapter/elasticsearch/adapter'

# jRuby specific overrides.
require 'veritas/adapter/elasticsearch/jruby'

module Veritas
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
