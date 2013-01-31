module Veritas
  module Adapter
    module Elasticsearch
      module Support
        # Lazy map an enumerable
        #
        # @param [#each] enumerable
        #
        # @return [Enumerator]
        #
        # @api private
        #
        def self.lazy_map(enumerable, &block)
          raise ArgumentError, 'required block not given' unless block_given?

          Enumerator.new do |yielder|
            map(enumerable, yielder, &block)
          end
        end

        # Map enumerable items into accumulator
        #
        # @param [#each] enumerable
        # @param [#<<] accumulator
        #
        # @return [self]
        #
        # @api private
        #
        def self.map(enumerable, accumulator)
          enumerable.each do |value|
            accumulator << yield(value)
          end

          self
        end
        private_class_method :map
      end
    end
  end
end
