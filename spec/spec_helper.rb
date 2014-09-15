require 'rspec'
require 'webmock/rspec'
require 'apiary'

Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }