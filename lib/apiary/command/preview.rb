# encoding: utf-8

require 'rest-client'
require 'rack'
require 'json'
require 'tmpdir'
require 'erb'
require 'launchy'
require 'listen'

require 'apiary/agent'
require 'apiary/helpers'
require 'apiary/helpers/javascript_helper'

module Apiary::Command
  # Display preview of local blueprint file
  class Preview
    include Apiary::Helpers
    include Apiary::Helpers::JavascriptHelper

    PREVIEW_TEMPLATE_PATH = "#{File.expand_path File.dirname(__FILE__)}/../file_templates/preview.erb".freeze

    attr_reader :options

    def initialize(opts)
      @options = OpenStruct.new(opts)
      @options.path         ||= '.'
      @options.api_host     ||= 'api.apiary.io'
      @options.port         ||= 8080
      @options.proxy        ||= ENV['http_proxy']
      @options.server       ||= false
      @options.json         ||= false
      @options.watch        ||= false
      @options.interval     ||= 1000
      @options.host         ||= '127.0.0.1'
      @options.headers      ||= {
        accept: 'text/html',
        content_type: 'text/plain',
        user_agent: Apiary.user_agent
      }

      @changed = timestamp

      begin
        @source_path = api_description_source_path(@options.path)
      rescue StandardError => e
        abort "#{e.message}"
      end
    end

    def execute
      if @options.server
        watch
        server
      else
        show
      end
    end

    def watch
      return unless @options.watch
      listener = Listen.to(File.dirname(@source_path), only: /#{File.basename(@source_path)}/) do |modified|
        @changed = timestamp
      end
      listener.start
    end

    def timestamp
      Time.now.getutc.to_i.to_s
    end

    def server
      generate_app = get_app(path: '/') do
        generate
      end

      change_app = get_app(path: '/changed', options: { 'Content-Type' => 'text/plain' }) do
        @changed
      end

      source_app = get_app(path: '/source', options: { 'Content-Type' => 'text/plain' }) do
        api_description_source(@source_path)
      end

      app = Rack::Builder.new do
        run Rack::Cascade.new([source_app, change_app, generate_app])
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

    def get_app(path: '/', options: {})
      Rack::Builder.new do
        map path do
          run ->(env) { [200, options, [yield]] }
        end
      end
    end

    def open_generated_page(path)
      def_browser = ENV['BROWSER']
      ENV['BROWSER'] = @options.browser

      Launchy.open(path) do |e|
        puts "Attempted to open `#{path}` and failed because #{e}"
      end
      ENV['BROWSER'] = def_browser
    end

    def write_generated_path(path, outfile)
      File.write(outfile, File.read(path))
    end

    def generate
      template = load_preview_template
      source = api_description_source(@source_path)

      return if source.nil?

      begin
        JSON.parse(source)
        abort('Did you forget the --json flag') unless @options.json
      rescue; end
      source = convert_from_json(source) if @options.json

      data = {
        title: File.basename(@source_path, '.*'),
        source: source,
        interval: @options.interval,
        watch: @options.watch
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
  end
end
