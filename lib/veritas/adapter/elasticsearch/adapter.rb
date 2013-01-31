module Veritas
  module Adapter
    module Elasticsearch
      class Adapter
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
end
