module Veritas
  module Adapter
    class Elasticsearch
      # Represent connection to a specific index
      class Index
        include Immutable

        # Return name of index
        #
        # @return [String]
        #
        # @api private
        #
        attr_reader :name

        # Return driver
        #
        # @return [Driver]
        #
        # @api private
        #
        attr_reader :driver

        # Refresh index
        #
        # @api private
        #
        # @return [self]
        #
        def refresh
          driver.refresh(name)
          self
        end

        # Drop index
        #
        # @return [self]
        #
        # @api private
        #
        def drop
          driver.drop(name)
          self
        end

        # Wait for index presence
        #
        # @param [Hash] options
        #
        # @return [self]
        #
        # @api private
        #
        def wait(options={})
          driver.wait(name, options)
          self
        end

        # Test if index does exist
        #
        # @return [true]
        #   if index does exist
        #
        # @return [false]
        #   otherwise
        #
        # @api private
        #
        def exist?
          driver.exist?(name)
        end

        # Refresh index
        #
        # @return [self]
        #
        # @api private
        #
        def refresh
          driver.refresh(name)
          self
        end

        # Setup index
        #
        # @param [Hash] settings
        #
        # @return [self]
        #
        # @api private
        #
        def setup(settings = {})
          driver.setup(name, settings)
          self
        end

        # Return tuples from query
        #
        # @param [String] path
        #   the elasticsearch path to query most likely a string with the index name
        #
        # @param [Hash] query
        #   the query in elasticsearch format as a hash
        #
        # @api private
        #
        # @return [Result]
        #   returns a result instance wrapping the decoded json body
        #
        def read(query)
          driver.read(name, query)
        end

        # Return type for index
        #
        # @param [String] name
        #
        # @return [Type]
        #
        # @api private
        #
        def type(name)
          Type.new(self, name)
        end

      private

        # Initialize object
        #
        # @param [Driver] driver
        # @param [String] name
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(driver, name)
          @driver, @name = driver, name
        end
      end
    end
  end
end
