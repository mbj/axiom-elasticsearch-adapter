module Veritas
  module Adapter
    class Elasticsearch
      class Query
        # A query where possible amount of results is unlimted
        class Unlimited < Query

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
