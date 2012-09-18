require 'multi_json'
require 'veritas'
require 'faraday'
require 'veritas/adapter/elasticsearch/support'
require 'veritas/adapter/elasticsearch/operations'
require 'veritas/adapter/elasticsearch/literal'
require 'veritas/adapter/elasticsearch/visitor'
require 'veritas/adapter/elasticsearch/query'
require 'veritas/adapter/elasticsearch/query/limited'
require 'veritas/adapter/elasticsearch/query/unlimited'
require 'veritas/adapter/elasticsearch/driver'
require 'veritas/adapter/elasticsearch/index'
require 'veritas/adapter/elasticsearch/middleware'
require 'veritas/adapter/elasticsearch/preprocessor'
require 'veritas/adapter/elasticsearch/preprocessor/request'
require 'veritas/adapter/elasticsearch/preprocessor/response'
require 'veritas/adapter/elasticsearch/result'
require 'veritas/adapter/elasticsearch/gateway'
require 'veritas/adapter/elasticsearch/null_logger'

# jRuby specific overrides.
require 'veritas/adapter/elasticsearch/jruby'

module Veritas
  module Adapter
    # An adapter for elasticsearch
    class Elasticsearch
      # Error raised when query on unsupported algebra is created
      class UnsupportedAlgebraError < StandardError; end
      # Error raised when elasticsearch http protocol is violated
      class ProtocolError < StandardError; end
      # Error raised when elasticsearch reports error
      class RemoteError < StandardError; end

      include Immutable


      # Return driver
      #
      # @return [Driver]
      #
      # @api private
      #
      attr_reader :driver

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

        Query.build(@driver, relation).each(&block)

        self
      end

    private

      # Initialize elasticsearch adapter
      #
      # @param [URI] uri
      #   the uri of elasticsearch node to access
      #
      # @return [undefined]
      #
      # @api private
      #
      def initialize(uri, options)
        @driver = Driver.new(uri, options)
      end
    end
  end
end
