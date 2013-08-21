require 'rubygems'
require "honey/version"
require "honey/cli"
Dir["#{File.dirname(__FILE__)}/honey/command/*.rb"].each { |f| require(f) }

module Honey
end
