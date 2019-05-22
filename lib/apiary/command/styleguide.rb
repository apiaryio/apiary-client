# encoding: utf-8

require 'rest-client'
require 'json'

require 'apiary/agent'
require 'apiary/helpers'
require 'apiary/exceptions'

module Apiary::Command
  class Styleguide
    include Apiary::Helpers

    attr_reader :options

    def initialize(opts)
      @options = OpenStruct.new(opts)
      @options.fetch        ||= false
      @options.add          ||= '.'
      @options.functions    ||= '.'
      @options.rules        ||= '.'
      @options.api_key      ||= ENV['APIARY_API_KEY']
      @options.proxy        ||= ENV['http_proxy']
      @options.api_host     ||= 'api.apiary.io'
      @options.vk_url       ||= 'https://voight-kampff.apiary-services.com'
      @options.headers      ||= {
        content_type: :json,
        accept: :json,
        user_agent: Apiary.user_agent
      }
      @options.failedOnly = !@options.full_report
      @options.json
    end

    def execute
      check_api_key
      if @options.fetch
        fetch
      elsif @options.push
        push
      else
        validate
      end
    end

    def push
      begin
        load(add: false)
      rescue StandardError => e
        abort "Error: #{e.message}"
      end

      path = 'styleguide-cli/set-assertions/'
      headers = @options.headers.clone
      headers[:authentication] = "Token #{@options.api_key}"

      data = {
        functions: @functions,
        rules: @rules
      }.to_json

      begin
        call_apiary(path, data, headers, :post)
      rescue => e
        puts e
        abort "Error: Can not write into the rules/functions file: #{e}"
      end
    end

    def fetch
      begin
        assertions = fetch_from_apiary
        assertions = JSON.parse(assertions)
      rescue => e
        abort "Error: Can not fetch rules and functions: #{e}"
      end

      begin
        File.write("./#{default_functions_file_name}", assertions['functions']['functions'])
        File.write("./#{default_rules_file_name}", JSON.pretty_generate(assertions['rules']['rules']))
        puts "`./#{default_functions_file_name}` and `./#{default_rules_file_name}` has beed succesfully created"
      rescue => e
        abort "Error: Can not write into the rules/functions file: #{e}"
      end
    end

    def validate
      token = jwt

      begin
        token = JSON.parse(token)['jwt']
      rescue JSON::ParserError => e
        abort "Can not authenticate: #{e}"
      end

      begin
        load
      rescue StandardError => e
        abort "Error: #{e.message}"
      end

      data = {
        functions: @functions,
        rules: @rules,
        add: @add,
        failedOnly: @options.failedOnly
      }.to_json

      headers = @options.headers.clone
      headers[:Authorization] = "Bearer #{token}"
      headers['Accept-Encoding'] = 'identity'

      output call_resource(@options.vk_url, data, headers, :post)
    end

    def print_output_text(result)
      lines = if result['sourcemapLines']['start'] == result['sourcemapLines']['end']
                "on line #{result['sourcemapLines']['start']}"
              else
                "on lines #{result['sourcemapLines']['start']} - #{result['sourcemapLines']['end']}"
              end

      if result['result'] == true
        puts "      [\u2713] PASSED: #{(result['path'] || '').gsub('-', ' #')} #{lines}"
      else
        puts "      [\u274C] FAILED: #{(result['path'] || '').gsub('-', ' #')} #{lines} - `#{result['result']}`"
      end
    end

    def json_output(json_response)
      puts JSON.pretty_generate json_response
    end

    def human_output(json_response)
      if json_response.empty?
        puts 'All tests has passed'
        exit 0
      end

      puts ''

      at_least_one_failed = false

      json_response.each do |response|
        puts "    #{(response['intent'] || response['ruleName'] || response['functionName'])}"

        (response['results'] || []).each do |result|
          print_output_text result
          at_least_one_failed = true if result['result'] != true
        end

        puts ''
      end

      if at_least_one_failed
        exit 1
      else
        exit 0
      end
    end

    def output(raw_response)
      begin
        json_response = JSON.parse(raw_response)
      rescue
        abort "Error: Can not parse result: #{raw_response}"
      end

      if @options.json
        json_output json_response
      else
        human_output json_response
      end
    end

    def default_rules_file_name
      'rules.json'
    end

    def default_functions_file_name
      'functions.js'
    end

    def call_apiary(path, data, headers, method)
      call_resource("https://#{@options.api_host}/#{path}", data, headers, method)
    end

    def call_resource(url, data, headers, method)
      RestClient.proxy = @options.proxy

      method = :post unless method

      begin
        response = RestClient::Request.execute(method: method, url: url, payload: data, headers: headers)
      rescue RestClient::Exception => e
        begin
          err = JSON.parse e.response
        rescue JSON::ParserError
          err = {}
        end

        message = 'Error: Apiary service responded with:'

        if err.key? 'message'
          abort "#{message} #{e.http_code} #{err['message']}"
        else
          abort "#{message} #{e.message}"
        end
      end
      response
    end

    def jwt
      path = 'styleguide-cli/get-token/'
      headers = @options.headers.clone
      headers[:authentication] = "Token #{@options.api_key}"
      call_apiary(path, {}, headers, :get)
    end

    def check_api_key
      return if @options.api_key && @options.api_key != ''
      abort 'Error: API key must be provided through environment variable APIARY_API_KEY. \Please go to https://login.apiary.io/tokens to obtain it.'
    end

    def load(add: true, functions: true, rules: true)
      if add
        @add_path = api_description_source_path(@options.add)
        @add = api_description_source(@add_path)
      end
      @functions = get_functions(@options.functions) if functions
      @rules = get_rules(@options.rules) if rules
    end

    def fetch_from_apiary
      path = 'styleguide-cli/get-assertions/'
      headers = @options.headers.clone
      headers[:authentication] = "Token #{@options.api_key}"
      call_apiary(path, {}, headers, :get)
    end

    def get_rules(path)
      JSON.parse get_file_content(get_path(path, 'rules'))
    end

    def get_functions(path)
      get_file_content(get_path(path, 'functions'))
    end

    def get_path(path, type)
      raise "`#{path}` not found" unless File.exist? path

      return path if File.file? path

      file =  case type
              when 'rules'
                default_rules_file_name
              else
                default_functions_file_name
              end

      path = File.join(path, file)

      return path if File.file? path
      raise "`#{path}` not found"
    end

    def get_file_content(path)
      source = nil
      File.open(path, 'r:bom|utf-8') { |file| source = file.read }
      source
    end
  end
end
