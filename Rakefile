# encoding: utf-8

require 'bundler/gem_tasks'

def gemspec
  @gemspec ||= eval(File.read('apiary.gemspec'), binding, '.gemspec')
end

desc 'Validate the gemspec'
task :gemspec do
  gemspec.validate
end
