require 'veritas'

module Veritas
  module Adapter
    class Elasticsearch
      # Convert relations into elasticsearch queries
      class QueryBuilder
        def initialize(relation)
          @relation = relation
        end

        def to_query
          @query ||= 
            begin
              dispatch(@relation)
              build_query
            end
        end

      private

        TABLE = Hash[
          [
            [ Veritas::Algebra::Restriction,       :visit_restriction     ],
            [ Veritas::Relation::Base,             :visit_base_relation   ],
            [ Veritas::Relation::Operation::Order, :visit_order_operation ],
            [ Veritas::Relation::Operation::Limit, :visit_limit_operation ],
            [ Veritas::Relation::Operation::Offset,:visit_offset_operation]
          ]
        ].freeze

        def dispatch(visitable)
          klass = visitable.class
          method = TABLE.fetch(klass) do
            raise ArgumentError,"Unsupported relation: #{klass}"
          end
          send(method,visitable)

          self
        end

        def build_query
          [ 
            [ 
              type, 
              build_query_inner
            ]
          ]
        end

        def build_query_inner
          [:from,:size,:filter,:fields,:sort].each_with_object({}) do |name,query|
            value = send(name)
            if value
              query.merge!(value)
            end
          end
        end

        def from
          @from
        end

        def size
          @size || Literal.size(100_000)
        end

        def filter
          @filter
        end

        def sort
          @sort
        end

        def fields
          @fields || raise("no fields")
        end

        def type
          @type || raise("no type")
        end

        def visit_order_operation(order)
          @sort = Literal.sort(order)
          dispatch(order.operand)

          self
        end

        def visit_restriction(restriction)
          @filter = Literal.filter(restriction.predicate)
          dispatch(restriction.operand)

          self
        end

        def visit_offset_operation(operation)
          @from = Literal.from(operation.offset)
          dispatch(operation.operand)

          self
        end


        def visit_limit_operation(operation)
          @size = Literal.size(operation.limit)
          dispatch(operation.operand)

          self
        end

        def visit_base_relation(relation)
          @fields = Literal.fields(relation.header.map(&:name))
          @type = relation.name

          self
        end
      end
    end
  end
end
