#!/usr/bin/env gem build
# encoding: utf-8

project_root = File.dirname(__FILE__)

$:.unshift(File.expand_path(File.join(project_root, "..")))

require "apiary/version"

Gem::Specification.new do |gem|
  gem.name    = "apiaryio"
  gem.version = Apiary::VERSION

  gem.author      = "Apiary Ltd."
  gem.email       = "team@apiary.io"
  gem.homepage    = "http://apiary.io/"
  gem.summary     = "Apiary.io API client"
  gem.description = "Apiary.io API client"
  gem.executables = "apiary"
  gem.license     = "MIT"

  gem.files = Dir.glob("#{project_root}/{lib,spec,apiary.gemspec,Gemfile,README.md,LICENSE}/**/*")

  gem.add_dependency "rest-client", "~> 1.6.1"
  gem.add_dependency "launchy",     ">= 0.3.2"
end
