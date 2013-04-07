module Axiom
  module Adapter
    module Elasticsearch
      # Abstract base class for queries
      #
      # TODO: Move all batch reading to elasticsearch gem
      #
      class Query
        include AbstractType, Enumerable, Adamantium::Flat, Concord.new(:visitor)

        # TODO: Should be configurable!
        BATCH_SIZE = 100

      private

        # Read results
        #
        # @return [Result]
        #
        # @api private
        #
        # This method is intentionally at private scope.
        # Its scope is set to public in subclasses.
        #
        # This saves the need to mutation cover this method
        # on instances of the abstract query class.
        #
        def each(&block)
          return to_enum(__method__) unless block_given?

          results.each do |result|
            tuples(result).each(&block)
          end

          self
        end

        # Return enumerator for tuples in result
        #
        # TODO: 
        #
        #   Many other hit / tuple mappings are possible.
        #   No need to rely on 'fields'
        #
        # @param [Result] result
        #
        # @return [Enumerator<Array>]
        #
        # @api private
        #
        def tuples(result)
          result.hits.map do |hit|
            hit.raw.fetch('fields').values_at(*fields)
          end
        end

        # Return field names in document
        #
        # @return [Enumerator<String>]
        #
        # @api private
        #
        def fields
          components.fetch(:fields).map { |field| field.to_s }
        end
        memoize :fields

        # Return query components
        #
        # @return [Hash]
        #
        # @api private
        #
        def components
          @visitor.components
        end

        # Return results enumerator
        #
        # @return [Enumerable<Result>]
        #
        # @api private
        #
        def results
          Enumerator.new do |yielder|
            bounds.each do |offset, size|
              result = read_slice(offset, size)
              yielder << result
              break if result.hits.size < size
            end
          end
        end

        # Return bounds enumerator
        #
        # @return [Enumerator<Integer, Integer>]
        #
        # @api private
        #
        abstract_method :bounds

        # Return results for offset and size
        #
        # @param [Integer] offset
        # @param [Integer] size
        #
        # @return [Result]
        #
        # @api private
        #
        def read_slice(offset, size)
          query = components.merge(
            :from => Literal.positive_integer(offset),
            :size => Literal.positive_integer(size)
          )
          @visitor.type.search(query)
        end

        # Return batch size
        #
        # @return [Integer]
        #
        # @api private
        #
        def batch_size
          self.class::BATCH_SIZE
        end

        # Return offset enumerator for queries
        #
        # @return [Enumerator<Integer>]
        #
        # @api private
        #
        def offsets
          Enumerator.new do |yielder|
            current = 0
            while current <= Literal::INT_32_MAX
              yielder << current
              current += batch_size
            end
            raise "Cannot read mor than #{Literal::INT_32_MAX} records!"
          end
        end

        # Build query instance from index and relation
        #
        # @param [Elasticsearch::Index] index
        # @param [Relation] relation
        #
        # @return [Query::Limited]
        #   in case result count is limited
        #
        # @return [Query::Unlimited]
        #   in case result count is unlimited
        #
        # @api private
        #
        def self.build(index, relation)
          visitor = Visitor.new(relation, index)
          klass = visitor.limited? ? Limited : Unlimited
          klass.new(visitor)
        end

        memoize :fields
      end
    end
  end
end
