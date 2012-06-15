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
            request.options.merge!(@read_options)
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
          if exist?
            connection.delete do |request|
              request.options[:expect_status]=200
            end 
          end

          self
        end

        # Check if index does exist
        #
        # @return [true|false]
        #
        # @api private
        #
        def exist?
          response = connection.head do |request|
            request.options[:expect_status]=[200,404]
          end

          response.status == 200
        end

        # Trigger refresh on index
        #
        # @return [self]
        #
        # @api private
        #
        def refresh
          connection.post('_refresh') do |request|
            request.options[:expect_status]=200
          end

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

        # Setup index
        #
        # Currently done with some hardcoded defaults.
        #
        # @return [self]
        def setup
          return if exist?

          options = { 
            'settings' => {
              'number_of_shards' => 1,
              'number_of_replicas' => 0
            }
          }

          p options

          connection.put do |request|
            request.options.merge!(:expect_status => 200, :convert_json => true)
            request.body = options
          end

          self
        end

      private

        DEFAULT_READ_OPTIONS = {
          :expect_status => 200,
          :convert_json  => true
        }.freeze

        # Initialize connection
        #
        # @param [String] uri
        #
        # @api private
        #
        def initialize(uri,options={})
          @uri= uri
          @adapter      = [*options.fetch(:adapter,:net_http)]
          @logger       = options.fetch(:logger,nil)
          @read_options = options.fetch(:read_options,DEFAULT_READ_OPTIONS)
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
            builder.adapter(*@adapter)
          end
        end
      end
    end
  end
end
