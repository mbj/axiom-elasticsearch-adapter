# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name        = 'axiom-elasticsearch-adapter'
  gem.version     = '0.0.1'
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@schirp-dso.com' ]
  gem.description = 'Elasticsearch adapter for axiom'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/mbj/axiom-elasticsearch-adapter'

  gem.require_paths    = [ 'lib' ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- spec`.split("\n")
  gem.extra_rdoc_files = %w[TODO]

  gem.add_runtime_dependency('axiom',         '~> 0.1.0')
  gem.add_runtime_dependency('adamantium',    '~> 0.0.7')
  gem.add_runtime_dependency('elasticsearch', '~> 0.1.0')
  gem.add_runtime_dependency('concord',       '~> 0.0.3')
end
