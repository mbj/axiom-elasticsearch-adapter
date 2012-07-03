module Veritas
  module Adapter
    class Elasticsearch
      module Literal
        # Maximum number an signed 32bit integer can take
        INT_32_MAX = (2**31 - 1).freeze

        # Minimum number an signed 32bit integer can take
        INT_32_MIN = (-2**31).freeze

        INT_32_RANGE = (INT_32_MIN..INT_32_MAX)

        # Check if object is a positive integer
        #
        # @param [Object] object
        #
        # @return [Fixnum] 
        #
        # @api private
        #
        def self.integer(object)
          unless object.kind_of?(Fixnum) and INT_32_RANGE.include?(object)
            raise ArgumentError, "Not a valid int32: #{object.inspect}"
          end

          object
        end

        # Check if value is postive
        #
        # @param [Object] value
        #
        # @return [#>=]
        #
        # @api private
        #
        def self.positive(value)
          unless value.kind_of?(Numeric) and value >= 0
            raise ArgumentError, "Not a positive value: #{value.inspect}"
          end

          value
        end
        private_class_method :positive

        # Chef if value is a positive integer
        #
        # @param [Object] value
        #
        # @return [Fixnum]
        #
        # @api private
        #
        def self.positive_integer(value)
          positive(integer(value))
        end

        # Create fields selection literal
        #
        # @param [Relation::Header] header
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.fields(header)
          header.map do |head|
            field(head.name)
          end
        end

        # Create field literal
        #
        # @param [#to_s] field
        #
        # @return [String]
        #
        # @api private
        #
        def self.field(field)
          field.to_s
        end
        private_class_method :field

        # Create size literal
        #
        # @param [Relation::Operation::Limit] operation
        #
        # @return [Fixnum]
        #
        # @api private
        #
        # TODO: Check for positive numeric value in elasticsearch allowed range
        #
        def self.size(operation)
          positive_integer(operation.limit)
        end

        # Create from literal
        #
        # @param [Relation::Operation::Offset] operation
        #
        # @return [Fixnum]
        #
        # @api private
        #
        # TODO: Check for positive numeric value in elasticsearch allowed range
        #
        def self.from(operation)
          positive_integer(operation.offset)
        end

        # Create filter literal from restriction
        #
        # @param [Algebra::Restriction] restriction
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.filter(restriction)
          function(restriction.predicate)
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

        OPERATIONS = Operations.new(
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
          Veritas::Function::Connective::Negation            => :create_inverse
        )

        # Create filter literal internals 
        #
        # @param [Veritas::Function] function
        #
        # @return [Hash]
        #
        # @api private
        #
        def self.function(function)
          send(*OPERATIONS.lookup(function))
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
