require 'veritas'

module Veritas
  module Adapter
    class Elasticsearch
      # Convert relations into elasticsearch queries
      class Query
        # Error raised when query on unsupported algebra is created
        class UnsupportedAlgebraError < StandardError; end

        # Return relation converted to elasticsearch query
        #
        # @return [Hash]
        #
        # @api private
        #
        def to_query
          query.last
        end

        # Return elasticsearch path to query
        #
        # @return [String]
        #
        # @api private
        #
        def path
          query.first
        end

        # Execute query on connection
        #
        # @param [Driver] driver
        #
        # @return [Result]
        #
        # @api private
        #
        def execute(driver)
          Result.new(@relation,driver.read(path,to_query))
        end

      private

        # Initialize query instance
        #
        # @param [Veritas::Relation] relation
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(relation)
          @relation = relation
        end

        TABLE = {
          Veritas::Algebra::Restriction        => :visit_restriction,
          Veritas::Relation::Base              => :visit_base_relation,
          Veritas::Relation::Operation::Order  => :visit_order_operation,
          Veritas::Relation::Operation::Limit  => :visit_limit_operation,
          Veritas::Relation::Operation::Offset => :visit_offset_operation
        }.freeze

        # Dispatch visitable 
        #
        # @param [Object] visitable
        #
        # @return [self]
        #
        # @api private
        #
        def dispatch(visitable)
          klass = visitable.class
          method = TABLE.fetch(klass) do
            raise UnsupportedAlgebraError,"Unsupported relation: #{klass}"
          end
          send(method,visitable)

          self
        end

        # Build query from stored fragments
        #
        # @return [Array]
        #
        # @api private
        #
        def query
          return @query if defined?(@query)
          dispatch(@relation)
          @query = [ @base_name, build_query_inner ]
        end

        # Build inner query from stored fragments
        #
        # @return [Array]
        #
        # @api private
        #
        def build_query_inner
          [:from,:size,:filter,:fields,:sort].each_with_object({}) do |name,query|
            value = send(name)
            if value
              query.merge!(value)
            end
          end
        end

        # Return visited from literal or nil if unset
        #
        # @return [Integer|nil]
        #
        # @api private
        #
        def from
          @from
        end

        # Return visited size literal or big number
        #
        # @return [Integer|100_000]
        #
        # @api private
        #
        # TODO: Elasticsearch needs an explict size. Is there a way to return all matched records?
        #
        def size
          @size || Literal.size(100_000)
        end

        # Return visited filter literal or nil if unset
        #
        # @return [Hash|nil]
        #
        # @api private
        #
        def filter
          @filter
        end

        # Return visited sort literal or nil if unset
        #
        # @return [Hash|nil]
        #
        # @api private
        #
        def sort
          @sort
        end

        # Return visted fields literal or raise
        #
        # @return [Hash|nil]
        #
        # @api private
        #
        def fields
          @fields || raise("no fields")
        end

        # Return relation base name or raise
        #
        # The relation base name is the elasticsearch path to query.
        #
        # @return [String]
        #
        # @api private
        #
        def base_name
          @base_name || raise('no base name was visited')
        end

        # Visit an order operation
        #
        # @param [Veritas::Relation::Operation::Order] operation
        #
        # @return [self]
        #
        # @api private
        #
        def visit_order_operation(operation)
          if defined?(@sort)
            raise UnsupportedAlgebraError,'Nesting order operations is not supported'
          end
          @sort = Literal.sort(operation)
          dispatch(operation.operand)

          self
        end

        # Visit an restriction operation
        #
        # @param [Veritas::Relation::Operation::Restriction] operation
        #
        # @return [self]
        #
        # @api private
        #
        def visit_restriction(operation)
          if defined?(@filter)
            raise UnsupportedAlgebraError, 'Nesting restrictions is not supported'
          end
          @filter = Literal.filter(operation.predicate)
          dispatch(operation.operand)

          self
        end

        # Visit an offset operation
        #
        # @param [Veritas::Relation::Operation::Offset] operation
        #
        # @return [self]
        #
        # @api private
        #
        def visit_offset_operation(operation)
          if defined?(@from)
            raise UnsupportedAlgebraError, 'Nesting offset operations is not supported'
          end
          @from = Literal.from(operation.offset)
          dispatch(operation.operand)

          self
        end

        # Visit a limit operation
        #
        # @param [Veritas::Relation::Operation::Limit] operation
        #
        # @return [self]
        #
        # @api private
        #
        def visit_limit_operation(operation)
          if defined?(@size)
            raise UnsupportedAlgebraError, 'Nesting limit operations is not supported'
          end
          @size = Literal.size(operation.limit)
          dispatch(operation.operand)

          self
        end

        # Visit a base relation
        #
        # @param [Veritas::Relation::Base] relation
        #
        # @return [self]
        #
        # @api private
        #
        def visit_base_relation(relation)
          @base_name = relation.name
          @fields = Literal.fields(relation.header)

          self
        end
      end
    end
  end
end
