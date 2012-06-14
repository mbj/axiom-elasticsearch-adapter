module Veritas
  module Adapter
    class Elasticsearch
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
            if convert_json?
              @env[:body] = JSON.dump(body)
            end

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
              logger.debug("#{method.upcase} #{url} #{body.inspect}")
            end

            self
          end
        end
      end
    end
  end
end
