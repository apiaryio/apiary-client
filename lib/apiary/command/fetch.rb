# encoding: utf-8

require 'rest-client'
require 'json'

require 'apiary/agent'

module Apiary::Command
  # Retrieve blueprint from apiary
  class Fetch
    def initialize(opts)
      @options = OpenStruct.new(opts)
      @options.api_host     ||= 'api.apiary.io'
      @options.api_name     ||= false
      @options.api_key      ||= ENV['APIARY_API_KEY']
      @options.proxy        ||= ENV['http_proxy']
      @options.headers      ||= {
        accept: 'text/html',
        content_type: 'text/plain',
        authentication: "Token #{@options.api_key}",
        user_agent: Apiary.user_agent
      }
    end

    def execute
      response = fetch_from_apiary

      return unless response.instance_of? String

      puts response
    end

    def fetch_from_apiary
      unless @options.api_name
        abort 'Please provide an api-name option (subdomain part from your https://<api-name>.docs.apiary.io/)'
      end

      unless @options.api_key
        abort 'API key must be provided through environment variable APIARY_API_KEY. Please go to https://login.apiary.io/tokens to obtain it.'
      end

      response = query_apiary

      if @options.output
        write_generated_path(response['code'], @options.output)
      else
        response['code']
      end
    end

    def query_apiary
      url = "https://#{@options.api_host}/blueprint/get/#{@options.api_name}"
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
