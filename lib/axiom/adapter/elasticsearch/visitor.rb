module Axiom
  module Adapter
    module Elasticsearch
      # Visit relations to contstruct query parts
      class Visitor
        include Adamantium

        # Return query components
        #
        # @return [Hash]
        #
        # @api private
        #
        attr_reader :components

        # Return elasticsearch type to read from
        #
        # @return [Elasticsearch::Type]
        #
        # @api private
        #
        attr_reader :type

        # Return index
        #
        # @return [Elasticsearch::Index]
        #
        # @api private
        #
        attr_reader :index

        # Test if amount of tuples  is limited
        #
        # @return [true]
        #   if amount of tuples is limited
        #
        # @return [false]
        #   otherwise
        #
        # @api private
        #
        def limited?
          components.key?(:size)
        end

      private

        # Initialize query instance
        #
        # @param [Axiom::Relation] relation
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(relation, index)
          @index, @components = index, {}
          dispatch(relation)
        end

        OPERATIONS = Operations.new(
          Axiom::Relation::Base              => [:visit_base_relation  ],
          Axiom::Algebra::Restriction        => [:assign, :filter      ],
          Axiom::Relation::Operation::Order  => [:assign, :sort        ],
          Axiom::Relation::Operation::Limit  => [:assign, :size        ],
          Axiom::Relation::Operation::Offset => [:assign, :from        ]
        )

        # Dispatch visitable
        #
        # @param [Relation] relation
        #
        # @return [self]
        #
        # @api private
        #
        def dispatch(relation)
          send(*OPERATIONS.lookup(relation))

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
        # @param [Axiom::Relation::Base] relation
        #
        # @return [self]
        #
        # @api private
        #
        def visit_base_relation(relation)
          @type = index.type(relation.name)
          components[:fields] = Literal.fields(relation.header)

          self
        end
      end
    end
  end
end
