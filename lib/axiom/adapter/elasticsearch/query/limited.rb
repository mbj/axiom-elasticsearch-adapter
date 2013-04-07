module Axiom
  module Adapter
    module Elasticsearch
      class Query
        # A query where amount of possible results is limited
        class Limited < Query

          # Read results
          #
          # @return [Result]
          #
          # @api private
          #
          # Yarddoc/Yardstick blows up with a single
          #   public :each
          #
          # For this reason this super is present :(
          #
          def each
            super
          end

        private

          # Return bounds enumerator for queries
          #
          # @return [Enumerator<Integer, Integer>]
          #
          # @api private
          #
          def bounds
            Enumerator.new do |yielder|
              offsets.each do |offset|
                yielder << [offset, slice_length(offset)]
              end
            end
          end

          # Return results enumerator
          #
          # @return [Enumerable<Result>]
          #
          # @api private
          #
          def results
            Enumerator.new do |yielder|
              read_to_maximum(super, yielder)
            end
          end

          # Read to maximum
          #
          # @param [Enumerator<Result>] results
          # @param [#<<] accumulator
          #
          # @return [undefined]
          #
          # @api private
          #
          def read_to_maximum(results, accumulator)
            count, maximum = 0, limit

            results.each do |result|
              count += result.size
              accumulator << result
              break if count == maximum
            end
          end

          # Return result count limit
          #
          # @return [Integer]
          #
          # @api private
          #
          def limit
            components.fetch(:size)
          end
          memoize :limit

          # Return slice length for given offset
          #
          # @return [Integer] offset
          #
          # @api private
          #
          def slice_length(offset)
            maximum, slice_length = limit, batch_size
            upper = offset + slice_length

            if upper > maximum
              slice_length = maximum - offset
            end

            slice_length
          end

        end
      end
    end
  end
end
