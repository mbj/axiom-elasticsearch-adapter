module Veritas
  module Adapter
    class Elasticsearch
      module Literal
        # Create fields literal
        #
        # @param [Vertias::Relation::Header] header
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.fields(header)
          header.map(&:name)
        end

        # Create size literal
        #
        # @param [Numeric] size
        #
        # @return [Hash]
        #
        # @api private
        #
        # TODO: Check for positive numeric value in elasticsearch allowed range
        #
        def self.size(size)
          size
        end

        # Create from literal
        #
        # @param [Numeric] offset
        #
        # @return [Hash]
        #
        # @api private
        #
        # TODO: Check for positive numeric value in elasticsearch allowed range
        #
        def self.from(offset)
          offset
        end

        # Create filter literal
        #
        # @param [Veritas::Function] function
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.filter(function)
          function(function)
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
          sort_operations(operation) 
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

        TABLE = {
          Veritas::Function::Predicate::Equality             => :equality_predicate,
          Veritas::Function::Predicate::Inequality           => :create_inverse,
          Veritas::Function::Predicate::Inclusion            => :inclusion_predicate,
          Veritas::Function::Predicate::Exclusion            => :create_inverse,
          Veritas::Function::Predicate::GreaterThan          => :greater_than_predicate,
          Veritas::Function::Predicate::GreaterThanOrEqualTo => :greater_than_or_equal_to_predicate,
          Veritas::Function::Predicate::LessThan             => :less_than_predicate,
          Veritas::Function::Predicate::LessThanOrEqualTo    => :less_than_or_equal_to_predicate,
          Veritas::Function::Connective::Disjunction         => :disjunction, 
          Veritas::Function::Connective::Conjunction         => :conjunction, 
          Veritas::Function::Connective::Negation            => :create_inverse, 
        }.freeze

        # Create filter literal internals 
        #
        # @param [Veritas::Function] function
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.function(function)
          klass = function.class

          method = TABLE.fetch(klass) do
            raise ArgumentError, "Unsupported function: #{klass}"
          end

          send(method,function)
        end
        private_class_method :function

        # Create filter literal internals from disjunction 
        #
        # @param [Veritas::Function::Predicate::Disjunction] disjunction
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.disjunction(disjunction)
          create_connective(disjunction,:or)
        end
        private_class_method :disjunction

        # Create filter literal internals from conjunction 
        #
        # @param [Veritas::Function::Predicate::Disjunction] conjunction
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.conjunction(conjunction)
          create_connective(conjunction,:and)
        end
        private_class_method :conjunction

        # Create connective literal
        #
        # @param [Veritas::Function::Connective] connective
        # @param [Symbol] operator
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.create_connective(connective,operator)
          { operator => [function(connective.left),function(connective.right)] }
        end
        private_class_method :create_connective

        # Create filter literal internals from quality predicate
        #
        # @param [Veritas::Function::Predicate::Equality] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.equality_predicate(predicate)
          create_filter(predicate,:term)
        end
        private_class_method :equality_predicate

        # Create filter literal internals from inclusion predicate
        #
        # @param [Veritas::Function::Predicate::Inclusion] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.inclusion_predicate(predicate)
          create_filter(predicate,:terms)
        end
        private_class_method :inclusion_predicate

        # Create filter literal internals from less than predicate
        #
        # @param [Veritas::Function::Predicate::LessThan] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.less_than_predicate(predicate)
          create_filter_operator(predicate,:range,:lt)
        end
        private_class_method :less_than_predicate

        # Create filter literal internals from less than or equal to predicate
        #
        # @param [Veritas::Function::Predicate::LessThanOrEqualTo] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.less_than_or_equal_to_predicate(predicate)
          create_filter_operator(predicate,:range,:lte)
        end
        private_class_method :less_than_or_equal_to_predicate

        # Create filter literal internals from greater than predicate
        #
        # @param [Veritas::Function::Predicate::GreaterThan] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.greater_than_predicate(predicate)
          create_filter_operator(predicate,:range,:gt)
        end
        private_class_method :greater_than_predicate

        # Create filter literal internals from greater than or equal to predicate
        #
        # @param [Veritas::Function::Predicate::GreaterThanOrEqualTo] predicate
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.greater_than_or_equal_to_predicate(predicate)
          create_filter_operator(predicate,:range,:gte)
        end
        private_class_method :greater_than_or_equal_to_predicate

        # Create filter from predicate and type
        #
        # @param [Veritas::Function::Predicate] predicate
        # @param [Symbol] type
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.create_filter(predicate,type)
          create_filter_operand(predicate,type,predicate.right)
        end
        private_class_method :create_filter

        # Create filter from predicate type and operator
        #
        # @param [Veritas::Function::Predicate] predicate
        # @param [Symbol] type
        # @param [Symbol] operator
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.create_filter_operator(predicate,type,operator)
          create_filter_operand(predicate,type,operator => predicate.right)
        end
        private_class_method :create_filter_operator

        # Create filter from predicate type and operand
        #
        # @param [Veritas::Function::Predicate] predicate
        # @param [Symbol] type
        # @param [Object] operand
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.create_filter_operand(predicate,type,operand)
          { type => { predicate.left.name => operand } }
        end
        private_class_method :create_filter_operand

        # Create inverted filter
        #
        # @param [Veritas::Function] function
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.create_inverse(function)
          { :not => function(function.inverse) }
        end
        private_class_method :create_inverse
      end
    end
  end
end
