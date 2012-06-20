# encoding: utf-8

module Veritas
  module Adapter
    class Elasticsearch
      # A relation backed by elasticserach adapter
      class Gateway < ::Veritas::Relation

        DECORATED_CLASS = superclass

        undef_method *DECORATED_CLASS.public_instance_methods(false).map(&:to_s) - %w[ materialize ]
        undef_method :restrict, :sort_by, :drop, :take

        # The adapter the gateway will use to fetch results
        #
        # @return [Adapter::DataObjects]
        #
        # @api private
        #
        attr_reader :adapter
        protected :adapter

        # The relation the gateway will use to generate SQL
        #
        # @return [Relation]
        #
        # @api private
        #
        attr_reader :relation
        protected :relation

        # Initialize a Gateway
        #
        # @param [Adapter::DataObjects] adapter
        #
        # @param [Relation] relation
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(adapter, relation)
          @adapter  = adapter
          @relation = relation
        end

        # Iterate over each row in the results
        #
        # @example
        #   gateway = Gateway.new(adapter, relation)
        #   gateway.each { |tuple| ... }
        #
        # @yield [tuple]
        #
        # @yieldparam [Tuple] tuple
        #   each tuple in the results
        #
        # @return [self]
        #
        # @api public
        #
        def each
          return to_enum unless block_given?
          tuples.each { |tuple| yield tuple }
          self
        end

        # Test if the method is supported on this object
        #
        # @param [Symbol] method
        #
        # @return [Boolean]
        #
        # @api private
        def respond_to?(method, *)
          super || forwardable?(method)
        end

      private

        # Proxy the message to the relation
        #
        # @param [Symbol] method
        #
        # @param [Array] *args
        #
        # @return [self]
        #   return self for all command methods
        # @return [Object]
        #   return response from all query methods
        #
        # @api private
        def method_missing(method, *args, &block)
          forwardable?(method) ? forward(method, *args, &block) : super
        end

        # Forward the message to the relation
        #
        # @param [Array] *args
        #
        # @return [self]
        #   return self for all command methods
        # @return [Object]
        #   return response from all query methods
        #
        # @api private
        def forward(*args, &block)
          relation = self.relation
          response = relation.public_send(*args, &block)

          if response.equal?(relation)
            self
          elsif response.kind_of?(DECORATED_CLASS)
            self.class.new(adapter, response)
          else
            response
          end
        end

        # Test if the method can be forwarded to the relation
        #
        # @param [Symbol] method
        #
        # @return [Boolean]
        #
        # @api private
        def forwardable?(method)
          relation.respond_to?(method)
        end

        # Return a list of tuples to iterate over
        #
        # @return [#each]
        #
        # @api private
        #
        def tuples
          relation = self.relation
          if materialized?
            relation
          else
            DECORATED_CLASS.new(header, adapter.read(relation))
          end
        end
      end
    end # class Gateway
  end # class Relation
end # module Veritas
