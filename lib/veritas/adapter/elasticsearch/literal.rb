module Veritas
  module Adapter
    class Elasticsearch
      module Literal
        def self.fields(fields)
          { :fields => fields }
        end

        def self.size(size)
          { :size => size }
        end

        def self.from(offset)
          { :from => offset }
        end

        def self.filter(predicate)
          { :filter => predicate(predicate) }
        end

        def self.sort(operation)
          { :sort => sort_operations(operation) }
        end

        def self.sort_operations(order)
          directions = order.directions.map do |operation|
            sort_operation(operation)
          end 
        end

        def self.sort_operation(operation)
          { operation.attribute.name => { :order => sort_direction(operation) } }
        end

        def self.sort_direction(operation)
          case operation
          when ::Veritas::Relation::Operation::Order::Descending
            :desc
          when ::Veritas::Relation::Operation::Order::Ascending
            :asc
          else
            raise "Unsupported operation: #{operation.class}"
          end
        end

        TABLE = Hash[
          [
            [ Veritas::Function::Predicate::Equality,     :equality_predicate ],
            [ Veritas::Function::Predicate::Inequality,   :inequality_predicate ],
            [ Veritas::Function::Connective::Disjunction, :disjunction ],
          ]
        ]

        def self.predicate(predicate)
          klass = predicate.class

          method = TABLE.fetch(klass) do
            raise "Unsupported predicate: #{klass}"
          end

          send(method,predicate)
        end

        def self.disjunction(predicate)
          { :or => [predicate(predicate.left),predicate(predicate.right)] }
        end

        def self.inequality_predicate(predicate)
          { :not => predicate(predicate.inverse) }
        end

        def self.equality_predicate(predicate)
          { :term => { predicate.left.name => predicate.right } }
        end
      end
    end
  end
end
