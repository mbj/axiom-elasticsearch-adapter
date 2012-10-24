module Veritas
  module Adapter
    class Elasticsearch
      # Wrap an elasticsearch result hash of hashes into poro world
      class Result
        include Enumerable, Immutable

        # Return wrapped data
        #
        # @return [Hash]
        #   the elasticsearch result body
        #
        # @api private
        #
        attr_reader :data

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

        # Return the number of hits
        #
        # @api private
        #
        # @return [Integer]
        #
        def size
          hits.size
        end

        # Return number of matched documents
        #
        # @api private
        #
        # @return [Fixnum]
        #
        def total_hits
          body.fetch('total')
        end

        # Return results 
        #
        # @return [Enumerable<Hash>]
        #
        # @api private
        #
        def documents
          p data
          hits.map do |hit|
            hit.fetch('fields')
          end
        end

        # Return hits
        #
        # @return [Enumerable<Hash>]
        #
        # @api private
        #
        def hits
          body.fetch('hits')
        end

        # Return body of result
        #
        # @return [Hash]
        #
        # @api private
        #
        def body
          @data.fetch('hits')
        end
        memoize :body

      private

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

        memoize :documents
      end
    end
  end
end
