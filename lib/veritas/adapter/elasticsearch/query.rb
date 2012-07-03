module Veritas
  module Adapter
    class Elasticsearch
      # Abstract base class for queries
      class Query
        include Enumerable, Immutable

        # Initialize query
        #
        # @param [Driver] driver
        # @param [Visitor] visitor
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(driver,visitor)
          @driver,@visitor = driver,visitor
        end

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
        # This frees us from the need to heckle this method
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
        # @param [Result] result
        #
        # @return [Enumerator<Array>]
        #
        # @api private
        #
        def tuples(result)
          result.documents.map do |document|
            document.values_at(*fields)
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
            read(yielder)
          end
        end

        # Read results into accumulator
        #
        # @param [#<<] accumulator
        #
        # @return [self]
        #
        # @api private
        #
        def read(accumulator)
          bounds.each do |offset,size|
            result = execute(offset,size)
            accumulator << result
            break if result.size < size
          end 

          self
        end

        # Return bounds enumerator
        #
        # @return [Enumerator<Integer,Integer>]
        #
        # @api private
        #
        def bounds
          raise NotImplementedError,"#{self.class}##{__method__} must be implemented"
        end

        # Return results for offset and size 
        #
        # @param [Integer] offset
        # @param [Integer] size
        #
        # @return [Result]
        #
        # @api private
        #
        def execute(offset,size)
          query = components.merge(
            :from => Literal.positive_integer(offset),
            :size => Literal.positive_integer(size)
          )
          @driver.read(@visitor.path,query)
        end

        # Return slice size
        #
        # @return [Integer]
        #
        # @api private
        #
        # TODO: Should be configurable. Maybe with adding Driver#slice_size?
        #
        def slice_size
          @driver.slice_size
        end

        # Return offset enumerator for queries
        #
        # @return [Enumerator<Integer>]
        #
        # @api private
        #
        def offsets
          0.step(Literal::INT_32_MAX,slice_size)
        end

        # Build query instance from driver and relation
        #
        # @param [Driver] driver
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
        def self.build(driver,relation)
          visitor = Visitor.new(relation)
          klass = visitor.limited? ? Limited : Unlimited
          klass.new(driver,visitor)
        end

        memoize :fields
      end
    end
  end
end
