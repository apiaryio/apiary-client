module Apiary
  USER_AGENT = "apiaryio-gem/#{Apiary::VERSION} (#{RUBY_PLATFORM}) ruby/#{RUBY_VERSION}".freeze

  module_function

  def user_agent
    @@user_agent ||= USER_AGENT
  end

  def user_agent=(agent)
    @@user_agent = agent
  end
end
