module Veritas
  module Adapter
    class Elasticsearch
      module Literal
        # Create fields literal
        #
        # @param [Array] fields
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.fields(fields)
          { :fields => fields }
        end

        # Create size literal
        #
        # @param [Numeric] size
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.size(size)
          { :size => size }
        end

        # Create from literal
        #
        # @param [Numeric] offset
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.from(offset)
          { :from => offset }
        end

        # Create filter literal
        #
        # @param [Veritas::Function::Predicate] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.filter(predicate)
          { :filter => predicate(predicate) }
        end

        # Create sort literal
        #
        # @param [Veritas::Relation::Operation::Order] operation
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.sort(operation)
          { :sort => sort_operations(operation) }
        end

        # Create sort operations literal
        #
        # @param [Veritas::Relation::Operation::Order] order
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.sort_operations(order)
          directions = order.directions.map do |operation|
            sort_operation(operation)
          end 
        end
        private_class_method :sort_operations

        # Create sort operation literal
        #
        # @param [Veritas::Relation::Operation::Order::Direction] operation
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.sort_operation(operation)
          { operation.attribute.name => { :order => sort_direction(operation) } }
        end
        private_class_method :sort_operation

        # Create sort operation direction literal
        #
        # @param [Veritas::Relation::Operation::Order::Direction] operation
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.sort_direction(operation)
          case operation
          when ::Veritas::Relation::Operation::Order::Descending
            :desc
          when ::Veritas::Relation::Operation::Order::Ascending
            :asc
          else
            raise ArgumentError,"Unsupported operation: #{operation.class}"
          end
        end
        private_class_method :sort_direction

        TABLE = Hash[
          [
            [ Veritas::Function::Predicate::Equality,     :equality_predicate ],
            [ Veritas::Function::Predicate::Inequality,   :inequality_predicate ],
            [ Veritas::Function::Connective::Disjunction, :disjunction ],
          ]
        ]

        # Create filter literal internals 
        #
        # @param [Veritas::Function::Predicate] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.predicate(predicate)
          klass = predicate.class

          method = TABLE.fetch(klass) do
            raise ArgumentError, "Unsupported predicate: #{klass}"
          end

          send(method,predicate)
        end
        private_class_method :predicate

        # Create filter literal internals from disjunction predicate
        #
        # @param [Veritas::Function::Predicate::Disjunction] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.disjunction(predicate)
          { :or => [predicate(predicate.left),predicate(predicate.right)] }
        end
        private_class_method :disjunction

        # Create filter literal internals from inequality predicate
        #
        # @param [Veritas::Function::Predicate::Inequality] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.inequality_predicate(predicate)
          { :not => predicate(predicate.inverse) }
        end
        private_class_method :inequality_predicate

        # Create filter literal internals from quality predicate
        #
        # @param [Veritas::Function::Predicate::Equality] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.equality_predicate(predicate)
          { :term => { predicate.left.name => predicate.right } }
        end
        private_class_method :equality_predicate
      end
    end
  end
end
