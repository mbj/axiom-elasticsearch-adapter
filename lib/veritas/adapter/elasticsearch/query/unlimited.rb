module Veritas
  module Adapter
    # Comment to make reek happy under 1.9
    class Elasticsearch
      # Comment to make reek happy under 1.9
      class Query
        # A query where possible amount of results is unlimted
        class Unlimited < Query
        private
          # Return bounds enumerator for queries
          #
          # @return [Enumerator<Integer,Integer>]
          #
          # @api private
          #
          def bounds
            Support.lazy_map(offsets) do |offset|
              [offset,slice_size]
            end
          end
        end
      end
    end
  end
end
