require 'rspec'
require 'webmock/rspec'

require 'support/aruba'

RSpec.configure do |config|
  config.filter_run_excluding :api_key => true if ENV['APIARY_API_KEY']
end
