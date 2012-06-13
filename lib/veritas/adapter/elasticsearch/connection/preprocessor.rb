module Veritas
  module Adapter
    class Elasticsearch
      # Base class for request and response preprocessor
      class Preprocessor

        # Invoke preprocessor on env
        #
        # @param [Hash] env
        #
        # @api private
        #
        # @return [self]
        #
        def self.run(env,logger)
          self.new(env,logger).preprocess

          self
        end

      protected

        # Return request method
        # 
        # @return [Symbol]
        #
        # @api private
        #
        def method
          @env[:method]
        end

        # Read request url
        #
        # @return [String]
        #
        # @api private
        #
        def url
          @env[:url]
        end

        # Return request or response body
        #
        # @return [Object]
        # 
        # @api private
        #
        def body
          @env[:body]
        end

        # Check if request is a bulk request
        #
        # @return [true|false]
        #
        # @api private
        #
        def bulk?
          url.to_s =~ /_bulk\Z/
        end

        # Return loggable body
        #
        # Will return "BULK" in case body is a bulk request.
        #
        # @return [String]
        #
        # @api private
        #
        def log_body
          bulk? ? 'BULK' : body
        end

        # Check if request method is HEAD
        #
        # @return [true|false]
        #
        # @api private
        #
        def head?
          method == :head
        end

        # Return logger
        #
        # @return [Logger]
        #
        # @api private
        #
        def logger
          @logger
        end

      private

        # Initialize preprecessor
        #
        # @param [Hash] env
        # @param [Logger] logger
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(env,logger)
          @env,@logger = env,logger
        end
      end
    end
  end
end
