# encoding: utf-8

require 'bundler/gem_tasks'

require 'yard'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

desc 'Run all features'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format pretty'
end

desc 'Run all specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = false
  t.verbose = true
end

def gemspec
  @gemspec ||= eval(File.read('apiary.gemspec'), binding, '.gemspec')
end

desc 'Validate the gemspec'
task :gemspec do
  gemspec.validate
end

YARD::Rake::YardocTask.new

# Aliases
desc 'Default: Run all specs.'
task :default => :spec

task :test => :spec
task :doc => :yard
task :gem => :gemspec
