module Veritas
  module Adapter
    class Elasticsearch
      # Elasticsearch query result 
      class Result
        include Enumerable

        # Enumerate rows in result
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

          rows.each(&block)

          self
        end

      private

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
        # @param [Virtus::Relation] relation
        # @param [Hash] data
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(relation,data)
          @relation,@data = relation,data
        end

        # Return enumerator on result rows
        #
        # @return [Enumerator<Array>]
        #
        # @api private
        #
        def rows
          hits.map do |hit|
            hit.fetch('fields').values_at(*fields)
          end
        end

        # Return field names
        #
        # @return [Array<String]
        #
        # @api private
        #
        def fields
          @fields ||= @relation.header.map { |attribute| attribute.name.to_s }.to_a
        end
      end
    end
  end
end
