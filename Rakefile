# encoding: utf-8
require "rubygems"
require "rspec/core/rake_task"
require 'yard'

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = true
end

desc 'Default: Run all specs.'
task :default => :spec

task :doc => :yard
task :gem => :gemspec

def gemspec
  @gemspec ||= eval(File.read('honey.gemspec'), binding, '.gemspec')
end

YARD::Rake::YardocTask.new

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end
