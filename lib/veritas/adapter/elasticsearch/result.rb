module Veritas
  module Adapter
    class Elasticsearch
      # Elasticsearch query result wrapper
      class Result
        include Enumerable

        # Return wrapped data
        #
        # @return [Hash]
        #   the elasticsearch result body
        #
        # @api private
        #
        def data
          @data
        end

        # Enumerate documents in result
        #
        # @yield [row]
        # @yieldparam [Array] row
        #
        # @return [self]
        #
        # @api private
        #
        def each(&block)
          return to_enum(__method__) unless block_given?

          documents.each(&block)

          self
        end

      private

        # Return enumerator on result documents
        #
        # @return [Enumerator<Hash>]
        #
        # @api private
        #
        def documents
          @documents ||= hits.map do |hit|
            hit.fetch('fields')
          end
        end

        # Return hits from result
        #
        # @return [Hash] hits
        #
        # @api private
        #
        def hits
          @data.fetch('hits').fetch('hits')
        end


        # Initialize result
        #
        # @param [Hash] data
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(data)
          @data = data
        end
      end
    end
  end
end
