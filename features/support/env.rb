require 'aruba/cucumber'
require 'fileutils'

Before do
  @dirs << "../../features/fixtures"
  ENV['PATH'] = "./bin#{File::PATH_SEPARATOR}#{ENV['PATH']}"  
end