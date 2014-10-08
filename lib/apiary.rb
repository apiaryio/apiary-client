require 'rubygems'
require "apiary/version"
require "apiary/cli"
require "apiary/common"
Dir["#{File.dirname(__FILE__)}/apiary/command/*.rb"].each { |f| require(f) }

module Apiary
end
