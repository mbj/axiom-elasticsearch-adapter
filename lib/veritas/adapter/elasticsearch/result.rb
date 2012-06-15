module Veritas
  module Adapter
    class Elasticsearch
      class Result
        def initialize(relation,data)
          @relation,@data = relation,data
        end

        def each(&block)
          return to_enum(__method__) unless block_given?

          tuples.each(&block)
        end

      private

        def hits
          @data.fetch('hits').fetch('hits')
        end

        def header
          @relation.header
        end

        def tuples
          hits.map do |hit|
            fields = hit.fetch('fields')
            Veritas::Tuple.new(header,fields.values)
          end
        end
      end
    end
  end
end
