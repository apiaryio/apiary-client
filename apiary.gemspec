# -*- encoding: utf-8 -*-
require File.expand_path('../lib/apiary/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Apiary Ltd."]
  gem.email         = ["team@apiary.io"]
  gem.description   = %q{Apiary.io CLI}
  gem.summary       = %q{Apiary.io CLI}
  gem.homepage      = "http://apiary.io"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "apiaryio"
  gem.require_paths = ["lib"]
  gem.version       = Apiary::VERSION

  gem.add_dependency "rest-client", "~> 1.0"
  gem.add_dependency "rack", "~> 1.6.4"
  gem.add_dependency "rake", "~> 10.4"
  gem.add_dependency "thor", "~> 0.19.1"

  gem.add_runtime_dependency "json", "~> 1.8"

  gem.add_development_dependency "rspec", "~> 3.2"
  gem.add_development_dependency "webmock", "~> 1.20"
  gem.add_development_dependency "yard", "~> 0.8"
  gem.add_development_dependency "aruba", ">= 0.6.2", "< 0.7.0"
  gem.add_development_dependency "cucumber", "~> 1.3", '>= 1.3.19'
end
