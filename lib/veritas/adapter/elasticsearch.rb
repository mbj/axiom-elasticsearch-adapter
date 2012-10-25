require 'veritas'
require 'elasticsearch'
require 'veritas/adapter/elasticsearch/support'
require 'veritas/adapter/elasticsearch/operations'
require 'veritas/adapter/elasticsearch/literal'
require 'veritas/adapter/elasticsearch/visitor'
require 'veritas/adapter/elasticsearch/query'
require 'veritas/adapter/elasticsearch/query/limited'
require 'veritas/adapter/elasticsearch/query/unlimited'
require 'veritas/adapter/elasticsearch/gateway'

# jRuby specific overrides.
require 'veritas/adapter/elasticsearch/jruby'

module Veritas
  module Adapter
    # An adapter for elasticsearch
    class Elasticsearch
      include Adamantium

      # Error raised when query on unsupported algebra is created
      class UnsupportedAlgebraError < StandardError; end

      # Error raised when elasticsearch http protocol is violated
      class ProtocolError < StandardError; end

      # Error raised when elasticsearch reports error
      class RemoteError < StandardError; end

      include Adamantium::Flat

      # Return connection
      #
      # @return [Elasticsearch::Connection]
      #
      # @api private
      #
      attr_reader :connection

      # Read tuples from relation
      #
      # @param [Relation] relation
      #   the relation to access
      #
      # @return [self]
      #   returns self when block given
      #
      # @return [Enumerable<Array>]
      #   returns enumerable when no block given
      #
      # @api private
      #
      def read(relation, &block)
        return to_enum(__method__, relation) unless block_given?

        Query.build(connection, relation).each(&block)

        self
      end

    private

      # Initialize elasticsearch adapter
      #
      # @param [Elasticsearch::Connection] connection
      #   the connection to elasticsearch node
      #
      # @return [undefined]
      #
      # @api private
      #
      def initialize(connection)
        @connection = connection
      end
    end
  end
end
