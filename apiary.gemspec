# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apiary/version'

Gem::Specification.new do |gem|
  gem.name          = 'apiaryio'
  gem.version       = Apiary::VERSION
  gem.authors       = ['Apiary Ltd.']
  gem.email         = ['team@apiary.io']

  gem.description   = 'Apiary.io CLI'
  gem.summary       = 'Apiary.io CLI'
  gem.homepage      = 'http://apiary.io'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.bindir        = 'bin'
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'rest-client', ['>= 1.8', '< 3.0']
  gem.add_runtime_dependency 'rack', '>= 1.6.4'
  gem.add_runtime_dependency 'thor', '~> 0.19.1'
  gem.add_runtime_dependency 'json', '~> 1.8'
  gem.add_runtime_dependency 'launchy', '~> 2.4'
  gem.add_runtime_dependency 'listen', '~> 2.0'

  gem.add_development_dependency 'bundler', '~> 1.12'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.4'
  gem.add_development_dependency 'webmock', '~> 2.2.0'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'aruba', '~> 0.14'
  gem.add_development_dependency 'cucumber', '~> 2.0'
  gem.add_development_dependency 'rubocop', '~> 0.41.2'
end
