require 'veritas'

module Veritas
  module Adapter
    class Elasticsearch
      # Visit relations to contstruct query parts
      class Visitor
        # Error raised when query on unsupported algebra is created
        class UnsupportedAlgebraError < StandardError; end

        # Return query components
        #
        # @return [Hash]
        #
        # @api private
        #
        def components
          @components 
        end

        # Return elasticsearch path to query
        #
        # @return [String]
        #
        # @api private
        #
        def path
          @base_name
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
          @components = {}
          dispatch(relation)
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

        # Assign component
        #
        # @param [Symbol] name
        # @param [Object] value
        #
        # @return [self]
        #
        # @api private
        #
        def assign(name,value)
          if @components.key?(name)
            yield
          else
            @components[name]=value
          end

          self
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
          assign(:sort,Literal.sort(operation)) do
            raise UnsupportedAlgebraError,'Nesting order operations is not supported'
          end

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
          assign(:filter,Literal.filter(operation.predicate)) do
            raise UnsupportedAlgebraError, 'Nesting restrictions is not supported'
          end

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
          assign(:from,Literal.from(operation.offset)) do
            raise UnsupportedAlgebraError, 'Nesting offset operations is not supported'
          end

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
          assign(:size,Literal.size(operation.limit)) do
            raise UnsupportedAlgebraError, 'Nesting limit operations is not supported'
          end

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

          @components[:fields] = Literal.fields(relation.header)

          self
        end
      end
    end
  end
end
