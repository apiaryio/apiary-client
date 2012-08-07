# encoding: utf-8
require "rest_client"
require "rack"

module Apiary
  module Command
    # Display preview of local blueprint file
    class Preview

      BROWSERS ||= {
        :safari => "Safari",
        :chrome => "Google Chrome",
        :firefox => "Firefox"
      }

      attr_reader :options

      def initialize(args)
        @options = {}
        @options[:apib_path]   = "apiary.apib"
        @options[:api_host]    = "api.apiary.io"
        @options[:headers]     = {:accept => "text/html", :content_type => "text/plain"}
        @options[:port]        = 8080
        @options.merge! args
      end

      def self.execute(args)
        args[:server] ? new(args).server : new(args).show
      end

      def server
        run_server
      end

      def show
        generate_static(apib_path)
      end

      def validate_apib_file(apib_file)
        unless File.exist?(apib_file)
          abort "Apiary definition file hasn't been found: #{apib_file.inspect}"
        end
      end

      def apib_path
        @options[:apib_path] || "#{File.basename(Dir.pwd)}.apib"
      end

      def browser
        BROWSERS[@options[:browser]]  || nil
      end

      def api_host
        @options[:api_host]
      end

      def port
        @options[:port]
      end

      def rack_app(&block)
        Rack::Builder.new do
          run lambda { |env| [200, Hash.new, [block.call]] }
        end
      end

      def run_server
        app = self.rack_app do
          self.query_apiary(api_host, apib_path)
        end

        Rack::Server.start(:Port => port, :app => app)
      end

      def preview_path(apib_path)
        basename = File.basename(apib_path)
        "/tmp/#{basename}-preview.html"
      end

      def query_apiary(host, apib_path)
        url  = "https://#{host}/blueprint/generate"
        data = File.read(apib_path)
        RestClient.post(url, data, @options[:headers])
      end

      # TODO: add linux and windows systems
      def open_generated_page(path)
        exec "open #{browser_options} #{path}"
      end

      def generate_static(apib_path)
        File.open(preview_path(apib_path), "w") do |file|
          file.write(query_apiary(api_host, apib_path))
          open_generated_page(file.path)
        end
      end

      private
        def browser_options
          "-a #{BROWSERS[@options[:browser].to_sym]}" if @options[:browser]
        end
    end
  end
end
