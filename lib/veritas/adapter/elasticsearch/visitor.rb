module Veritas
  module Adapter
    class Elasticsearch
      # Visit relations to contstruct query parts
      class Visitor
        include Immutable

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

        # Return if query results are limited
        #
        # @return [true|false]
        #
        # @api private
        # 
        def limited?
          components.key?(:size)
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

        OPERATIONS = Operations.new(
          Veritas::Relation::Base              => [:visit_base_relation  ],
          Veritas::Algebra::Restriction        => [:assign, :filter      ],
          Veritas::Relation::Operation::Order  => [:assign, :sort        ],
          Veritas::Relation::Operation::Limit  => [:assign, :size        ],
          Veritas::Relation::Operation::Offset => [:assign, :from        ]
        )

        # Dispatch visitable
        #
        # @param [Object] visitable
        #
        # @return [self]
        #
        # @api private
        #
        def dispatch(visitable)
          send(*OPERATIONS.lookup(visitable))

          self
        end

        # Assign component from operation
        #
        # @param [Object] name
        # @param [Symbol] operation
        #
        # @return [self]
        #
        # @api private
        #
        def assign(name, operation)
          components = self.components

          if components.key?(name)
            raise UnsupportedAlgebraError, "No support for nesting #{operation.class}"
          end

          components[name]=Literal.send(name, operation)
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
          components[:fields] = Literal.fields(relation.header)

          self
        end
      end
    end
  end
end
