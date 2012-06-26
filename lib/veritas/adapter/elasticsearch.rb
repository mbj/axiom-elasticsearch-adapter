require 'json'
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
require 'veritas/adapter/elasticsearch/middleware'
require 'veritas/adapter/elasticsearch/preprocessor'
require 'veritas/adapter/elasticsearch/preprocessor/request'
require 'veritas/adapter/elasticsearch/preprocessor/response'
require 'veritas/adapter/elasticsearch/result'
require 'veritas/adapter/elasticsearch/gateway'

module Veritas
  module Adapter
    # An adapter for elasticsearch
    class Elasticsearch
      # Error raised when query on unsupported algebra is created
      class UnsupportedAlgebraError < StandardError; end
      # Error raised when elasticsearch http protocol is violated
      class ProtocolError < StandardError; end

      # Initialize elasticsearch adapter
      #
      # @param [URI] uri
      #   the uri of elasticsearch node to access
      #
      # @return [undefined]
      #
      # @api private
      #
      def initialize(uri,options)
        @uri,@options = uri,options
      end

      # Return URI of elasticsearch node
      #
      # @return [String]
      #
      # @api private
      #
      def uri
        @uri
      end

      # Return options of adapter
      #
      # @return [Hash]
      #
      # @api private
      #
      def options
        @options
      end

      # Read tuples from relation
      #
      # @param [Relation] relation
      #   the relation to access
      #
      # @return [Enumerable]
      #
      # @api private
      #
      def read(relation,&block)

        return to_enum(__method__, relation) unless block_given?

        Query.build(driver,relation).each(&block)

        self
      end

    private

      # Return driver
      #
      # @return [Driver]
      #
      # @api private
      #
      def driver
        @driver ||= Driver.new(@uri,@options)
      end
    end
  end
end
