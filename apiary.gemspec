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

  gem.add_dependency "rest-client", "~> 1.6.7"
  gem.add_dependency "rack", ">= 1.4.0", "< 1.6.0"
  gem.add_dependency "rake", "~> 10.3.2"
  gem.add_dependency "thor", "~> 0.19.1"

  gem.add_runtime_dependency "json", "~> 1.8.1"

  gem.add_development_dependency "rspec", "~> 3.1.0"
  gem.add_development_dependency "webmock"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "aruba"
  gem.add_development_dependency "cucumber"

end
