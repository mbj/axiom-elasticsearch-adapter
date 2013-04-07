module Veritas
  module Adapter
    module Elasticsearch
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
            Enumerator.new do |yielder|
              offsets.each do |offset|
                yielder << [offset, SLICE_SIZE]
              end
            end
          end

        end
      end
    end
  end
end
