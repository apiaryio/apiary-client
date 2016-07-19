# encoding: utf-8
require 'rest-client'
require 'rack'
require 'ostruct'
require 'json'
require 'tmpdir'
require 'erb'

require 'apiary/agent'
require 'apiary/helpers'
require 'apiary/helpers/javascript_helper'

module Apiary::Command
  # Display preview of local blueprint file
  class Preview
    include Apiary::Helpers
    include Apiary::Helpers::JavascriptHelper

    PREVIEW_TEMPLATE_PATH = "#{File.expand_path File.dirname(__FILE__)}/../file_templates/preview.erb".freeze

    BROWSERS = {
      safari: 'Safari',
      chrome: 'Google Chrome',
      firefox: 'Firefox'
    }.freeze

    attr_reader :options

    def initialize(opts)
      @options = OpenStruct.new(opts)
      @options.path         ||= '.'
      @options.api_host     ||= 'api.apiary.io'
      @options.port         ||= 8080
      @options.proxy        ||= ENV['http_proxy']
      @options.server       ||= false
      @options.host         ||= '127.0.0.1'
      @options.headers      ||= {
        accept: 'text/html',
        content_type: 'text/plain',
        user_agent: Apiary.user_agent
      }

      begin
        @source_path = api_description_source_path(@options.path)
      rescue StandardError => e
        abort "#{e.message}"
      end
    end

    def execute
      if @options.server
        server
      else
        show
      end
    end

    def server
      app = rack_app do
        generate
      end

      Rack::Server.start(Port: @options.port, Host: @options.host, app: app)
    end

    def show
      preview_string = generate

      File.open(preview_path, 'w') do |file|
        file.write preview_string
        file.flush
        @options.output ? write_generated_path(file.path, @options.output) : open_generated_page(file.path)
      end
    end

    def browser
      BROWSERS[@options.browser] || nil
    end

    def rack_app
      Rack::Builder.new do
        run ->(env) { [200, {}, [yield]] }
      end
    end

    # TODO: add linux and windows systems
    def open_generated_page(path)
      exec "open #{browser_options} #{path}"
    end

    def write_generated_path(path, outfile)
      File.write(outfile, File.read(path))
    end

    def generate
      template = load_preview_template

      data = {
        title: File.basename(@source_path, '.*'),
        source: api_description_source(@source_path)
      }

      template.result(binding)
    end

    def preview_path
      basename = File.basename(@source_path, '.*')
      temp = Dir.tmpdir
      "#{temp}/#{basename}-preview.html"
    end

    def load_preview_template
      file = File.open(PREVIEW_TEMPLATE_PATH, 'r')
      template_string = file.read
      ERB.new(template_string)
    end

    private

    def browser_options
      "-a #{BROWSERS[@options.browser.to_sym]}" if @options.browser
    end
  end
end
