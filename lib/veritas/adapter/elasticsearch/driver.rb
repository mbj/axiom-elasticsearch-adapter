module Veritas
  module Adapter
    class Elasticsearch
      # Augment a faraday connection with elasticsearch specific operations
      class Driver 
        # Return tuples from query
        #
        # @param [String] path
        # @param [Hash] query
        #
        # @api private
        #
        # @return [Hash]
        #
        def read(path,query)
          path = "#{path}/_search"

          response = connection.get(path) do |request|
            request.body = query
          end
          # end.body works but is not catched by rcov :(
          response.body
        end

        # Drop index if exist
        #
        # @return [self]
        #
        # @api private
        #
        def drop(index)
          if exist?(index)
            connection.delete(index) 
          end

          self
        end

        # Wait for index to be fully initialized
        #
        # @param [String] index
        # @param [Hash] options
        #
        # @return [self]
        #
        # @api private
        #
        def wait(index,options={})
          defaults = {
            :wait_for_status => :green,
            :timeout => 60,
            :level => :index
          }

          connection.get("_cluster/health/#{index}", defaults.merge(options)) 

          self
        end

        # Check if index does exist
        #
        # @return [true|false]
        #
        # @api private
        #
        def exist?(index)
          connection.head(index) do |request|
            request.options.merge!(:convert_json => false, :expect_status => [200,404])
          end.status == 200
        end

        # Trigger refresh on index
        #
        # @return [self]
        #
        # @api private
        #
        def refresh(index=nil)
          path = "#{index}/_refresh"

          connection.post(path) 

          self
        end

        # Setup index
        #
        # @param [String] index
        # @param [Hash] settings
        #
        # @return [self]
        #
        # @api private
        #
        def setup(index,settings=DEFAULT_INDEX_SETTINGS)
          connection.put("#{index}") do |request|
            request.body = settings
          end

          self
        end

      private

        DEFAULT_READ_OPTIONS = {
          :expect_status => 200,
          :convert_json  => true
        }.freeze

        DEFAULT_INDEX_SETTINGS = {
          'settings' => {
            'number_of_shards' => 1,
            'number_of_replicas' => 0
          }
        }.freeze

        # Initialize connection
        #
        # @param [String] uri
        #
        # @api private
        #
        def initialize(uri,options={})
          @uri     = uri
          @options = options
        end

        # Return http connection
        #
        # @return [Faraday::Connection]
        #
        # @api private
        #
        def connection
          @connection ||= Faraday.new(@uri) do |builder|
            adapter = [*@options.fetch(:adapter,:net_http)]
            logger  = @options.fetch(:logger,nil)
            builder.use(Middleware,logger)
            builder.adapter(*adapter)
          end
        end
      end
    end
  end
end
