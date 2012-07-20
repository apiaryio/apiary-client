#!/usr/bin/env gem build
# encoding: utf-8

project_root = File.dirname(__FILE__)

$:.unshift(File.expand_path(File.join(project_root, "lib")))

require "apiary/version"

Gem::Specification.new do |gem|
  gem.name    = "apiaryio"
  gem.version = Apiary::VERSION

  gem.authors     = ["Apiary Ltd.", "James C Russell aka botanicus"]
  gem.email       = "team@apiary.io"
  gem.homepage    = "http://apiary.io/"
  gem.summary     = "Apiary.io API client"
  gem.description = "Apiary.io API client"
  gem.executables = "apiary"
  gem.license     = "MIT"

  gem.files = Dir.glob("#{project_root}/{lib,spec,apiary.gemspec,Gemfile,README.md,LICENSE}/**/*")

  gem.add_dependency "nake"
  gem.add_dependency "rest-client", "~> 1.6.1"

  gem.post_install_message = "This gem is a client for http://apiary.io. Apiary is in closed beta version now, you need an invitation. If you don't have one, visit http://apiary.us2.list-manage.com/subscribe?u=b89934a238dcec9533f4a834a&id=08f2bdde55 to get on the waiting list!"
end
