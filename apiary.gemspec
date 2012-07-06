#!/usr/bin/env gem build
# encoding: utf-8

$:.unshift File.expand_path("../lib", __FILE__)

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

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(License|README|bin/|data/|ext/|lib/|spec/|test/)} }
  gem.add_dependency "rest-client", "~> 1.6.1"
  gem.add_dependency "launchy",     ">= 0.3.2"
end