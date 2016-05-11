# encoding: utf-8
require 'thor'
require 'apiary/command/fetch'
require 'apiary/command/preview'
require 'apiary/command/publish'

module Apiary
  class CLI < Thor

    desc 'fetch', 'Fetch API Description Document from API_NAME.apiary.io'
    method_option :api_name, :type => :string, :required => true
    method_option :api_host, :type => :string, :banner => 'HOST', :desc => 'Specify apiary host'
    method_option :output, :type => :string, :banner => 'FILE', :desc => 'Write API Description Document into specified file'

    def fetch
      cmd = Apiary::Command::Fetch.new options
      cmd.execute
    end

    desc 'preview', 'Show API documentation in default browser'
    method_option :browser, :type => :string, :enum => %w(chrome safari firefox), :banner => 'chrome|safari|firefox', :desc => 'Show API documentation in specified browser'
    method_option :output, :type => :string, :banner => 'FILE', :desc => 'Write generated HTML into specified file'
    method_option :path, :type => :string, :desc => 'Specify path to API Description Document. When given a directory, it will look for apiary.apib or swagger.yaml file'
    method_option :api_host, :type => :string, :banner => 'HOST', :desc => 'Specify apiary host'
    method_option :server, :type => :boolean, :desc => 'Start standalone web server on port 8080'
    method_option :port, :type => :numeric, :banner => 'PORT', :desc => 'Set port for --server option'
    method_option :host, :type => :string, :desc => 'Set host for --server option'

    def preview
      cmd = Apiary::Command::Preview.new options
      cmd.execute
    end

    desc 'publish', 'Publish API Description Document on docs.API_NAME.apiary.io'
    method_option :message, :type => :string, :banner => 'COMMIT_MESSAGE', :desc => 'Publish with custom commit message'
    method_option :path, :type => :string, :desc => 'Specify path to API Description Document. When given a directory, it will look for apiary.apib or swagger.yaml file'
    method_option :api_host, :type => :string, :banner => 'HOST', :desc => 'Specify apiary host'
    method_option :api_name, :type => :string, :required => true

    def publish
      cmd = Apiary::Command::Publish.new options
      cmd.execute
    end

    desc 'version', 'Show version'
    method_option :aliases => "-v"

    def version
      puts Apiary::VERSION
    end
  end
end
