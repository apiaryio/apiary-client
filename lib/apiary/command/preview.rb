# encoding: utf-8
require 'rest_client'
require 'rack'
require 'ostruct'
require 'json'

module Apiary
  module Command
    # Display preview of local blueprint file
    class Preview

      BROWSERS = {
        :safari => "Safari",
        :chrome => "Google Chrome",
        :firefox => "Firefox"
      }

      attr_reader :options

      # TODO: use OpenStruct to store @options
      def initialize(opts)
        @options = OpenStruct.new(opts)
        @options.path         ||= "apiary.apib"
        @options.api_host     ||= "api.apiary.io"
        @options.headers      ||= {:accept => "text/html", :content_type => "text/plain"}
        @options.port         ||= 8080
        @options.proxy        ||= ENV['http_proxy']
      end

      def self.execute(args)
        args[:server] ? new(args).server : new(args).show
      end

      def server
        run_server
      end

      def show
        generate_static(path)
      end

      def validate_apib_file(apib_file)
        unless File.exist?(apib_file)
          abort "Apiary definition file hasn't been found: #{apib_file.inspect}"
        end
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
          self.query_apiary(@options.api_host, @options.path)
        end

        Rack::Server.start(:Port => @options.port, :app => app)
      end

      def preview_path(path)
        basename = File.basename(@options.path)
        "/tmp/#{basename}-preview.html"
      end

      def query_apiary(host, path)
        url  = "https://#{host}/blueprint/generate"
        data = File.read(path)
        RestClient.proxy = @options.proxy

        begin
          RestClient.post(url, data, @options.headers)
        rescue RestClient::BadRequest => e
          err = JSON.parse e.response
          if err.has_key? 'parserError'
            abort "#{err['message']}: #{err['parserError']} (Line: #{err['line']}, Column: #{err['column']})"
          else
            abort "Apiary service responded with an error: #{err['message']}"
          end
        rescue RestClient::Exception => e
          abort "Apiary service responded with an error: #{e.message}"
        end
      end

      # TODO: add linux and windows systems
      def open_generated_page(path)
        exec "open #{browser_options} #{path}"
      end

      def write_generated_path(path, outfile)
        File.open(outfile, 'w') do |file|
          file.write(File.open(path, 'r').read)
        end
      end

      def generate_static(path)
        File.open(preview_path(path), "w") do |file|
          file.write(query_apiary(@options.api_host, path))
          @options.output ? write_generated_path(file.path, @options.output) : open_generated_page(file.path)
        end
      end

      private
        def browser_options
          "-a #{BROWSERS[@options.browser.to_sym]}" if @options.browser
        end
    end
  end
end
