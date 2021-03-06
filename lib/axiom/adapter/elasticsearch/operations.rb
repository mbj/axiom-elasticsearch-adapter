module Axiom
  module Adapter
    module Elasticsearch
      # A container for registring operations
      class Operations
        include Adamantium

        # Lookup operation based on visitable object
        #
        # @param [Object] visitable
        #
        # @return [Array]
        #
        # @api private
        #
        def lookup(visitable)
          klass = visitable.class
          call = @map.fetch(klass) do
            raise UnsupportedAlgebraError,"No support for #{klass}"
          end

          [*call] + [visitable]
        end

      private

        # Initialize operations
        #
        # @param [Hash<Class,Array>] map
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(map)
          @map = map.dup.freeze
        end
      end
    end
  end
end
