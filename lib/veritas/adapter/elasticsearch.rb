require 'json'
require 'veritas'
require 'faraday'
require 'veritas/adapter/elasticsearch/literal'
require 'veritas/adapter/elasticsearch/query'
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

#     # Read tuples from relation
#     #
#     # @param [Relation] relation
#     #   the relation to access
#     #
#     # @return [Enumerable]
#     #
#     # @api private
#     #
#     def read(relation,&block)
#       return to_enum(__method__, relation) unless block_given?

#       Query.new(relation).read(driver,&block)

#       self
#     end

#   private

#     # Return driver
#     #
#     # @return [Driver]
#     #
#     # @api private
#     #
#     def driver
#       @driver ||= Driver.new(@uri,@options)
#     end
    end
  end
end
