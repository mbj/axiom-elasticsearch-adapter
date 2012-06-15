require 'json'
require 'veritas'
require 'faraday'
require 'veritas/adapter/elasticsearch/literal'
require 'veritas/adapter/elasticsearch/query_builder'
require 'veritas/adapter/elasticsearch/connection'
require 'veritas/adapter/elasticsearch/middleware'
require 'veritas/adapter/elasticsearch/preprocessor'
require 'veritas/adapter/elasticsearch/preprocessor/request'
require 'veritas/adapter/elasticsearch/preprocessor/response'
require 'veritas/adapter/elasticsearch/result'

module Veritas
  module Adapter
    # An adapter for elasticsearch
    class Elasticsearch
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

        builder = QueryBuilder.new(relation)

        result = Result.new(relation,connection.read(*builder.to_query))
        result.each(&block)
      end

    private

      # Access connection
      #
      # @return [Connection]
      #
      # @api private
      #
      def connection
        @connection ||= Connection.new(@uri,@options)
      end
    end
  end
end
