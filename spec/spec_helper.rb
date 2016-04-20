require 'rspec'
require 'webmock/rspec'
require 'apiary'

RSpec.configure do |config|
  config.filter_run_excluding :api_key => true if ENV['APIARY_API_KEY']
end

Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
