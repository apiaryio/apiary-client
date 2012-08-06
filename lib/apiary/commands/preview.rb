# encoding: utf-8
require "rest_client"

# Display preview of local blueprint file
module Apiary
  module Commands
    class Preview

      BROWSERS ||= {
        safari: "Safari",
        chrome: "Google Chrome",
        firefox: "Firefox"
      }

      attr_reader :options

      def initialize(args)
        @options = {}
        @options[:description] = "Display preview of local blueprint file"
        @options[:apib_path] = "/Users/emili/Work/current/apiary/demo-api/apiary.apib"
        @options[:api_host]  = "api.apiary.io"
        @options[:headers]   = {accept: "text/html", content_type: "text/plain"}
        @options[:browser]   = "Google Chrome"
        @options[:port]      = 8080
        @options.merge! args
      end

      def self.show(args={})
        new(args).show
      end

      def self.server(args={})
        new(args).server
      end

      def server
        run_server(@options)
      end

      def show
        self.generate_static(default_apib_path, @options)
      end

      def validate_apib_file(apib_file)
        unless File.exist?(apib_file)
          abort "Apiary definition file hasn't been found: #{apib_file.inspect}"
        end
      end

      def default_apib_path
        @options[:apib_path] || "#{File.basename(Dir.pwd)}.apib"
      end

      def browser(options)
        BROWSERS[@options[:browser].to_sym] || @options[:browser] || BROWSERS[@options[:browser]] || @options[:browser]
      end

      def api_host(options)
        @options[:api_host] || @options[:api_host]
      end

      def port(options)
        @options[:port] || config[:port]
      end

      def rack_app(&block)
        Rack::Builder.new do
          run lambda { |env| [200, Hash.new, [block.call]] }
        end
      end

      def run_server(options)
        require "rack"

        port = @options[:port]

        app = self.rack_app do
          host = self.api_host(@options)
          self.query_apiary(host, @options[:apib_path])
        end

        Rack::Server.start(Port: port, app: app)
      rescue LoadError
        puts "If you want to run the server, you need rack:"
        puts
        puts "  gem install rack"
        exit 1
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

      def open_generated_page(path, options)
        exec "open -a '#{self.browser(options)}' '#{path}'"
      end

      # TODO: Support non OS X systems again. Could be done
      # through launchy or similar projects, but launchy seemed
      # to be tad buggy to me (ignored application I wanted to use),
      # so for now it's done through the open command.
      def generate_static(apib_path, options)
        File.open(self.preview_path(apib_path), "w") do |file|
          file.write(self.query_apiary(self.api_host(options), apib_path))
          self.open_generated_page(file.path, options)
        end
      end

    end
  end
end
