# encoding: utf-8
require "rubygems"
require "rspec/core/rake_task"
require 'yard'
require 'cucumber'
require 'cucumber/rake/task'
begin
      require 'bundler/gem_tasks'
rescue LoadError
      puts "Cannot load bundler/gem_tasks"
end

desc "Run all features"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = true
end

desc 'Default: Run all specs.'
task :default => :spec

task :test => :spec

task :doc => :yard
task :gem => :gemspec

def gemspec
  @gemspec ||= eval(File.read('apiary.gemspec'), binding, '.gemspec')
end

YARD::Rake::YardocTask.new

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end
