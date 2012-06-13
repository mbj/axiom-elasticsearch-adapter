require 'veritas'
require 'veritas/adapter/elasticsearch/literal'
require 'veritas/adapter/elasticsearch/query_builder'

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
      def initialize(uri)
        @uri = uri
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

    # # Read tuples from relation
    # #
    # # @param [Relation] relation
    # #   the relation to access
    # def read(relation,&block)
    #   return to_enum(__method__, relation) unless block_given?

    #   Query.new(connection,relation).each(&block)
    # end
    end
  end
end
