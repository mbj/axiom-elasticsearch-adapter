module Veritas
  module Adapter
    # Comment to make reek happy under 1.9
    class Elasticsearch
      # Comment to make reek happy under 1.9
      class Query
        # A query where amount of possible results is limited
        class Limited < Query
        private
          # Return bounds enumerator for queries
          #
          # @return [Enumerator<Integer,Integer>]
          #
          # @api private
          #
          def bounds
            Support.lazy_map(offsets) do |offset|
              [offset,slice_length(offset)]
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
              read_to_maximum(super,yielder)
            end
          end

          # Read results into accumulator until maximum amount of results is read
          #
          # @param [Enumerator<Result>] results
          # @param [#<<] accumulator
          #
          # @return [self]
          #
          # @api private
          #
          def read_to_maximum(results,accumulator)
            count,maximum = 0, limit

            results.each do |result|
              count+=result.size
              accumulator << result
              break if count == maximum
            end

            self
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

          # Return slice length for give noffset
          #
          # @return [Integer] offset
          #
          # @api private
          #
          def slice_length(offset)
            maximum = limit
            upper = offset + slice_size
            if upper < maximum
              upper
            else
              maximum - offset
            end
          end
        end
      end
    end
  end
end
