# encoding: utf-8

require 'veritas-elasticsearch-adapter'
require 'rspec'

include Veritas

# require spec support files and shared behavior
Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each { |f| require f }
