require 'aruba/cucumber'

Before('@needs_apiary_api_key') do
  @aruba_timeout_seconds = 30
end
