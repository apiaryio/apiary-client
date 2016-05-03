require 'aruba/cucumber'

Before('@needs_apiary_api_key') do
  @aruba_timeout_seconds = 45
end

Around('@needs_apiary_api_key') do |scenario, block|
  # DEBUG puts "Scenario #{scenario.name} wants APIARY_API_KEY."
  original_value = ENV.delete("APIARY_API_KEY");
  ENV["APIARY_API_KEY"] = "340bda135034529ab2abf341295c3aa2" # XXX
  block.call
  ENV["APIARY_API_KEY"] = original_value
end

Around('@doesnt_need_apiary_api_key') do |scenario, block|
  # DEBUG puts "Scenario #{scenario.name} doesn't want APIARY_API_KEY."
  original_value = ENV.delete("APIARY_API_KEY");
  block.call
  ENV["APIARY_API_KEY"] = original_value
end
