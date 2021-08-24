# encoding: utf-8

require 'rest-client'
require 'json'

require 'apiary/agent'

module Apiary::Command
  # Retrieve blueprint from apiary
  class Archive
    def initialize(opts)
      @options = OpenStruct.new(opts)
      @options.api_host     ||= 'api.apiary.io'
      @options.api_key      ||= ENV['APIARY_API_KEY']
      @options.proxy        ||= ENV['http_proxy']
      @options.headers      ||= {
        accept: 'application/json',
        content_type: 'application/json',
        authorization: "Bearer #{@options.api_key}",
        user_agent: Apiary.user_agent
      }
    end

    def execute
      response = apilist_from_apiary

      return unless response.instance_of? String

      puts response
    end

    def apilist_from_apiary
      unless @options.api_key
        abort 'API key must be provided through environment variable APIARY_API_KEY. Please go to https://login.apiary.io/tokens to obtain it.'
      end

      response = query_apiary

      response['apis'].each do |api|
        puts api['apiSubdomain']
        @options = OpenStruct.new
        @options.api_host     ||= 'api.apiary.io'
        @options.api_name     ||= api['apiSubdomain']
        @options.api_key      ||= ENV['APIARY_API_KEY']
        @options.proxy        ||= ENV['http_proxy']
        @options.output       ||= api['apiSubdomain'] + '.apib'
        @options.headers      ||= {
          accept: 'text/html',
          content_type: 'text/plain',
          authentication: "Token #{@options.api_key}",
          user_agent: Apiary.user_agent
        }
        cmd = Apiary::Command::Fetch.new(@options)
        cmd.execute
      end
    end

    def query_apiary
      url = "https://#{@options.api_host}/me/apis"
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
  end
end
