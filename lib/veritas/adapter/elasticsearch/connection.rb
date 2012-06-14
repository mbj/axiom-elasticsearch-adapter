module Veritas
  module Adapter
    class Elasticsearch
      # Augment a faraday connection with elasticsearch specific operations
      class Connection 
        # Return tuples from query
        #
        # @param [Symbol] type
        # @param [Hash] query
        #
        # @api private
        #
        # @return [Hash]
        #
        def read(type,query)
          response = connection.get("#{type}/_search") do |request|
            request.body = query
          end

          response.body
        end

        # Drop index if exist
        #
        # @return [self]
        #
        # @api private
        #
        def drop
          connection.delete if exist?

          self
        end

        # Check if index does exist
        #
        # @return [true|false]
        #
        # @api private
        #
        def exist?
          response = connection.head
          response.status == 200
        end

        # Trigger refresh on index
        #
        # @return [self]
        #
        # @api private
        #
        def refresh
          connection.post('_refresh')

          self
        end

        # Return connection logger
        #
        # @return [Logger]
        #
        # @api private
        #
        def logger
          @logger
        end

      private

        # Initialize connection
        #
        # @param [String] uri
        #
        # @api private
        #
        def initialize(uri,logger=nil)
          @uri,@logger = uri,logger
        end

        # Return http connection
        #
        # @return [Faraday::Connection]
        #
        # @api private
        #
        def connection
          @connection ||= Faraday.new(@uri) do |builder|
            builder.use(Middleware,@logger)
            builder.adapter(*adapter)
          end
        end

        # Return http adapter arguments to use
        #
        # @return [Array]
        #
        # @api private
        #
        def adapter
          [:net_http]
        end
      end
    end
  end
end
