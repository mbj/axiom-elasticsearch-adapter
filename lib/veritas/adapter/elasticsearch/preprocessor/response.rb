module Veritas
  module Adapter
    class Elasticsearch
      class Preprocessor
        # Response preprocessor
        class Response < Preprocessor
          # Preprocess response
          #
          # @return [self]
          #
          # @api private
          #
          def run
            raise_on_error
            convert_json
            log

            self
          end

        private

          # Raise if response is an error
          #
          # @return [self]
          #
          # @raise [RuntimeError]
          #
          # @api private
          #
          def raise_on_error
            if !head? and error_status?
              raise "Remote error: #{body}"
            end

            self
          end

          # Return response status
          #
          # @return [Fixnum]
          #
          # @api private
          #
          def status
            @env.fetch(:status)
          end

          # Load json request body
          #
          # @return [self]
          #
          # @api private
          #
          def convert_json
            body = self.body
            if body and content_type == 'application/json; charset=UTF-8'
              @env[:body] = JSON.load(body)
            end

            self
          end

          # Return response content type
          #
          # @return [String]
          #
          # @api private
          #
          def content_type
            response_headers.fetch('content_type',nil)
          end

          # Return response headers
          #
          # @return [Hash]
          #
          # @api private
          # 
          def response_headers
            @env.fetch(:response_headers)
          end

          # Check for error status code
          #
          # @return [true,false]
          #
          # @api private
          #
          def error_status?
            (400..600).include?(status)
          end

          # Log this response
          #
          # @return [self]
          #
          # @api private
          #
          def log
            logger = self.logger

            if logger
              logger.debug("#{status}")
            end

            self
          end
        end
      end
    end
  end
end
