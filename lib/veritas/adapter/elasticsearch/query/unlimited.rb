module Veritas
  module Adapter
    class Elasticsearch
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
