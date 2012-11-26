# -*- encoding: utf-8 -*-

require File.expand_path('../lib/veritas/adapter/elasticsearch/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'veritas-elasticsearch-adapter'
  gem.version     = Veritas::Adapter::Elasticsearch::VERSION.dup
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@seonic.net' ]
  gem.description = 'Elasticsearch adapter for veritas'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/mbj/veritas-elasticsearch-adapter'

  gem.require_paths    = [ 'lib' ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- spec`.split("\n")
  gem.extra_rdoc_files = %w[TODO]

  gem.add_runtime_dependency('backports',     '~> 2.6.1')
  gem.add_runtime_dependency('elasticsearch', '~> 0.0.1')
  gem.add_runtime_dependency('veritas',       '~> 0.0.7')
end
