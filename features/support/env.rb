require 'aruba/cucumber'
require 'fileutils'

Before do
  @dirs << "../../features/fixtures"
  ENV['PATH'] = "./bin#{File::PATH_SEPARATOR}#{ENV['PATH']}"
end

# https://gist.github.com/larrycai/2022360
module ArubaOverrides
  def detect_ruby(cmd)
    processor, platform, *rest = RUBY_PLATFORM.split("-")
    #puts platform
    if platform =~ /w32$/ && cmd =~ /^mkbok / #mkbok is the real command in features
      "ruby -I../../lib -S ../../bin/#{cmd}"
    else
      "#{cmd}"
    end
  end
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

World(ArubaOverrides)
