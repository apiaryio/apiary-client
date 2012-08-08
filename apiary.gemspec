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
  gem.add_dependency "rack", "~> 1.4.1"

  gem.add_development_dependency "rspec",   "~> 2.11.0"
  gem.add_development_dependency "yard",    "~> 0.8.2.1"

  gem.post_install_message = "This gem is a client for http://apiary.io. Apiary is in closed beta version now, you need an invitation. If you don't have one, visit http://apiary.us2.list-manage.com/subscribe?u=b89934a238dcec9533f4a834a&id=08f2bdde55 to get on the waiting list!"
end
