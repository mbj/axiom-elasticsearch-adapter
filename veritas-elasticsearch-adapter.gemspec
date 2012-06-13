# -*- encoding: utf-8 -*-

require File.expand_path('../lib/veritas/adapter/elasticsearch/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'veritas-elasticsearch-adapter'
  gem.version     = Veritas::Adapter::Elasticsearch::VERSION
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@seonic.net' ]
  gem.description = 'Elasticsearch adapter for virtus'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/mbj/veritas-elasticsearch-adapter'

  gem.require_paths    = [ 'lib' ]
  gem.files            = `git ls-files`.split('\n')
  gem.test_files       = `git ls-files -- {spec}/*`.split('\n')
  gem.extra_rdoc_files = %w[LICENSE README.md TODO]

  gem.add_runtime_dependency('backports', '~> 2.5.3')
  gem.add_runtime_dependency('faraday',   '~> 0.8.1')

  gem.add_development_dependency('rake',        '~> 0.9.2')
  gem.add_development_dependency('rspec',       '~> 1.3.2')
  gem.add_development_dependency('guard-rspec', '~> 0.7.0')
end
