# encoding: utf-8
require 'rest_client'
require 'rack'
require 'ostruct'
require 'json'

module Apiary
  module Command
    # Retrieve blueprint from apiary
    class Fetch

      attr_reader :options

      # TODO: use OpenStruct to store @options
      def initialize(opts)
        @options = OpenStruct.new(opts)
        @options.path         ||= "apiary.apib"
        @options.api_host     ||= "api.apiary.io"
        @options.api_name     ||= false
        @options.api_key      ||= ENV['APIARY_API_KEY']
        @options.proxy        ||= ENV['http_proxy']
        @options.headers      ||= {
          :accept => "text/html",
          :content_type => "text/plain",
          :authentication => "Token #{@options.api_key}"
        }
      end

      def execute()
        response = fetch_from_apiary
        if response.instance_of? String
          puts response
        end
      end

      def fetch_from_apiary
        unless @options.api_name
          abort "Please provide an api-name option (subdomain part from your http://docs.<api-name>.apiary.io/)"
        end

        unless @options.api_key
          abort "API key must be provided through environment variable APIARY_API_KEY. Please go to https://login.apiary.io/tokens to obtain it."
        end

        response = self.query_apiary(@options.api_host, @options.path)
        unless @options.output
          response["code"]
        else
          write_generated_path(response["code"], @options.output)
        end
      end

      def path
        @options.path || "#{File.basename(Dir.pwd)}.apib"
      end

      def query_apiary(host, path)
        url  = "https://#{host}/blueprint/get/#{@options.api_name}"
        RestClient.proxy = @options.proxy

        begin
          response = RestClient.get url, @options.headers
        rescue RestClient::Exception => e
          abort "Apiary service responded with an error: #{e.message}"
        end

        JSON.parse response.body
      end

      def write_generated_path(data, outfile)
        File.open(outfile, 'w') do |file|
          file.write(data)
        end
      end

      private
        def api_name
          "-a"
        end

    end
  end
end
