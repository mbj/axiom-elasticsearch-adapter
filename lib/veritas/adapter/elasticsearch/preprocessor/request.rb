module Veritas
  module Adapter
    # Comment to make reek happy under 1.9
    class Elasticsearch
      # Comment to make reek happy under 1.9
      class Preprocessor
        # Request preprocessor
        class Request < Preprocessor

          # Do preprocessing on request 
          #
          # @return [self]
          #
          # @api private
          #
          def run
            convert_json
            log

            self
          end

        private

          # Convert body to json
          # 
          # @return [self]
          #
          # @api private
          #
          def convert_json
            return unless convert_json?

            body = self.body

            @env[:body] = JSON.dump(body) if body

            self
          end

          # Log this request
          #
          # @return [self]
          #
          # @api private
          #
          def log
            logger = self.logger

            if logger
              logger.debug("#{method.upcase} #{url} #{body}")
            end

            self
          end
        end
      end
    end
  end
end
