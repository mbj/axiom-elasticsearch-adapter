module Veritas
  module Adapter
    class Elasticsearch
      class Type
        include Veritas::Immutable

        # Initialize object
        #
        # @param [Adapter::Elasticsearch::Index] index
        # @param [String] name
        #
        # @return [undefined]
        #
        # @api private
        #
        def initialize(index, name)
          @index, @name = index, name
        end

        attr_reader :index, :name

        # Create document 
        #
        # @param [String] id
        # @param [Hash] document
        #
        # @return [self]
        #
        # @api private
        #
        def create(id, document)
          index.driver.connection.post("#{index.name}/#{name}/#{id}?op_type=create") do |request|
            request.options[:expect_status]=201
            request.options[:convert_json]=201
            request.body = document
          end

          self
        end

        # Update document
        #
        # @param [String] id
        # @param [Hash] document
        #
        # @return [self]
        #
        # @api private
        #
        def update(id, document)
          index.driver.connection.post("#{index.name}/#{name}/#{id}?op_type=index") do |request|
            request.options[:expect_status]=200
            request.options[:convert_json]=200
            request.body = document
          end

          self
        end

        # Delete document
        #
        # @param [String] id
        # @param [Hash] document
        #
        # @return [self]
        #
        # @api private
        #
        def delete(id)
          index.driver.connection.delete("#{index.name}/#{name}/#{id}") do |request|
            request.options[:expect_status]=200
            request.options[:convert_json]=200
          end

          self
        end

      end
    end
  end
end
