# encoding: utf-8
require 'rest-client'
require 'rack'
require 'ostruct'
require 'json'
require 'tmpdir'
require 'erb'

require "apiary/common"
require "apiary/helpers/javascript_helper"

module Apiary
  module Command
    # Display preview of local blueprint file
    class Preview

      include Apiary::Helpers::JavascriptHelper

      PREVIEW_TEMPLATE_PATH = "#{File.expand_path File.dirname(__FILE__)}/../file_templates/preview.erb"

      BROWSERS = {
        :safari => 'Safari',
        :chrome => 'Google Chrome',
        :firefox => 'Firefox'
      }

      attr_reader :options

      def initialize(opts)
        @options = OpenStruct.new(opts)
        @options.path         ||= 'apiary.apib'
        @options.api_host     ||= 'api.apiary.io'
        @options.port         ||= 8080
        @options.proxy        ||= ENV['http_proxy']
        @options.server       ||= false
        @options.host         ||= '127.0.0.1'
        @options.headers      ||= {
          :accept => 'text/html',
          :content_type => 'text/plain',
          :user_agent => Apiary::USER_AGENT
        }

        validate_apib_file
      end

      def execute
        if @options.server
          server
        else
          show
        end
      end

      def server
        run_server
      end

      def show
        generate_static
      end

      def validate_apib_file
        @common = Apiary::Common.new
        @common.validate_apib_file(@options.path)
      end

      def path
        @options.path || "#{File.basename(Dir.pwd)}.apib"
      end

      def browser
        BROWSERS[@options.browser]  || nil
      end

      def rack_app(&block)
        Rack::Builder.new do
          run lambda { |env| [200, Hash.new, [block.call]] }
        end
      end

      def run_server
        app = self.rack_app do
          generate
        end

        Rack::Server.start(:Port => @options.port, :Host => @options.host, :app => app)
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
          title: File.basename(@options.path, '.*'),
          blueprint: load_blueprint
        }

        template.result(binding)
      end

      def generate_static
        preview_string = generate

        File.open(preview_path, 'w') do |file|
          file.write preview_string
          file.flush
          @options.output ? write_generated_path(file.path, @options.output) : open_generated_page(file.path)
        end
      end

      def load_blueprint
        file = File.open @options.path, 'r'
        file.read
      end

      def preview_path
        basename = File.basename(@options.path, '.*')
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
end
