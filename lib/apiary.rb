require 'rubygems'
require "apiary/version"
require "apiary/cli"
Dir["#{File.dirname(__FILE__)}/apiary/command/*.rb"].each { |f| require(f) }

module Apiary
end
