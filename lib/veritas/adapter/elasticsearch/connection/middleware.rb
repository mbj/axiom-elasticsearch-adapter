module Veritas
  module Adapter
    class Elasticsearch
      # Augment a faraday connection with elasticsearch specific operations
      class Connection 
        # Middleware namespace
        module Middleware
          # A Faraday response middleware for elasticsearch
          class Response < ::Faraday::Response::Middleware
            # Initialize response middleware
            #
            # @param [Object] app
            # @param [Logger] logger
            #
            # @return [undefined]
            #
            # @api private
            #
            def initialize(app,logger=nil)
              super(app)
              @logger = logger
            end

            # Callback from faraday
            #
            # @param [Hash] env
            #
            # @return [self]
            #
            # @api private
            #
            def on_complete(env)
              Preprocessor::Response.run(env,@logger)

              self
            end
          end

          # A Faraday request middleware for elasticsearch
          class Request

            # Middleware call from faraday
            #
            # @param [Hash] env
            #
            # @return [self]
            #
            # @api private
            #
            def call(env)
              Preprocessor::Request.run(env,@logger)

              @app.call(env)
            end

          private

            # Initialize request middleware
            #
            # @param [object] app
            #
            # @return [undefined]
            #
            # @api private
            #
            def initialize(app,logger=nil)
              @app,@logger = app,logger
            end
          end
        end
      end
    end
  end
end
