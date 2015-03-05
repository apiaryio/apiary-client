# encoding: utf-8
require 'rest_client'
require 'rack'
require 'ostruct'
require 'json'
require "apiary/common"

module Apiary
  module Command
    # Display preview of local blueprint file
    class Publish

      attr_reader :options

      def initialize(opts)
        @options = OpenStruct.new(opts)
        @options.path           ||= "apiary.apib"
        @options.api_host       ||= "api.apiary.io"
        @options.api_name       ||= false
        @options.api_key        ||= ENV['APIARY_API_KEY']
        @options.proxy          ||= ENV['http_proxy']
        @options.headers        ||= {
          :accept => "text/html",
          :content_type => "text/plain",
          :authentication => "Token #{@options.api_key}"
        }
        @options.commit_message ||= "Saving blueprint from apiary-client"
      end

      def execute()
        publish_on_apiary
      end

      def publish_on_apiary
        unless @options.api_name
          abort "Please provide an api-name option (subdomain part from your http://docs.<api-name>.apiary.io/)"
        end

        unless @options.api_key
          abort "API key must be provided through environment variable APIARY_API_KEY. Please go to https://login.apiary.io/tokens to obtain it."
        end

        self.query_apiary(@options.api_host, @options.path)

      end

      def validate_apib_file(apib_file)
        common = Apiary::Common.new
        common.validate_apib_file(apib_file)
      end

      def get_apib_file(apib_file)
        common = Apiary::Common.new
        common.get_apib_file(apib_file)
      end

      def path
        @options.path || "#{File.basename(Dir.pwd)}.apib"
      end

      def query_apiary(host, path)
        url  = "https://#{host}/blueprint/publish/#{@options.api_name}"
        if validate_apib_file path
          data = {
            :code => get_apib_file(path),
            :messageToSave => @options.commit_message
          }
          RestClient.proxy = @options.proxy

          begin
            RestClient.post url, data, @options.headers
          rescue RestClient::BadRequest => e
            err = JSON.parse e.response
            if err.has_key? 'parserError'
              abort "#{err['message']}: #{err['parserError']}"
            else
              abort "Apiary service responded with an error: #{err['message']}"
            end
          rescue RestClient::Exception => e
            abort "Apiary service responded with an error: #{e.message}"
          end
        end
      end

      private
        def api_name
          "-a"
        end

    end
  end
end
