# encoding: utf-8

require 'veritas-elasticsearch-adapter'
require 'spec'
require 'spec/autorun'

include Veritas

# require spec support files and shared behavior
Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each { |f| require f }

Spec::Runner.configure do |config|
  config.extend Spec::ExampleGroupMethods

  # Record the original Attribute descendants
  config.before do
    @original_descendants = Attribute.descendants.dup
  end

  # Reset the Attribute descendants
  config.after do
    Attribute.descendants.replace(@original_descendants)
  end

end
