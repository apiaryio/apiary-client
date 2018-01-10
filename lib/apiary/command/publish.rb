# encoding: utf-8

require 'rest-client'
require 'json'

require 'apiary/agent'
require 'apiary/helpers'

module Apiary::Command
  # Display preview of local blueprint file
  class Publish
    include Apiary::Helpers

    attr_reader :options

    def initialize(opts)
      @options = OpenStruct.new(opts)
      @options.path           ||= '.'
      @options.json           ||= false
      @options.api_host       ||= 'api.apiary.io'
      @options.api_name       ||= false
      @options.api_key        ||= ENV['APIARY_API_KEY']
      @options.proxy          ||= ENV['http_proxy']
      @options.headers        ||= {
        accept: 'text/html',
        content_type: 'text/plain',
        authentication: "Token #{@options.api_key}",
        user_agent: Apiary.user_agent
      }
      @options.message ||= 'Saving API Description Document from apiary-client'

      begin
        @source_path = api_description_source_path(@options.path)
      rescue StandardError => e
        abort "#{e.message}"
      end
    end

    def execute
      publish_on_apiary
    end

    def publish_on_apiary
      unless @options.api_name
        abort 'Please provide an api-name option (subdomain part from your http://docs.<api-name>.apiary.io/)'
      end

      unless @options.api_key
        abort 'API key must be provided through environment variable APIARY_API_KEY. \Please go to https://login.apiary.io/tokens to obtain it.'
      end

      query_apiary
    end

    def query_apiary
      url = "https://#{@options.api_host}/blueprint/publish/#{@options.api_name}"
      source = api_description_source(@source_path)

      return if source.nil?

      begin
        JSON.parse(source)
        abort('Did you forget the --json flag?') unless @options.json
      rescue; end
      source = convert_from_json(source) if @options.json
      data = {
        code: source,
        messageToSave: @options.message,
        shouldCommit: @options.push ? 'yes' : 'no'
      }

      RestClient.proxy = @options.proxy

      begin
        RestClient.post url, data, @options.headers
      rescue RestClient::BadRequest => e
        err = JSON.parse e.response
        if err.key? 'parserError'
          abort "#{err['message']}: #{err['parserError']}"
        else
          abort "Apiary service responded with an error: #{err['message']}"
        end
      rescue RestClient::Exception => e
        err = JSON.parse e.response
        if err.key? 'message'
          abort "Apiary service responded with an error: #{err['message']}"
        else
          abort "Apiary service responded with an error: #{e.message}"
        end
      end
    end
  end
end
