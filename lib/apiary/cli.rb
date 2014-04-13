# encoding: utf-8
require 'optparse'
module Apiary
  class CLI

    attr_reader :command

    def initialize(args)
      options = parse_options!(args)
      @command = options.delete(:command)
      run(options)
    end

    def run(options)
      Apiary::Command::Runner.run(@command, options)
    end

    def parse_options!(args)
      options = {}
      command = nil
      if args.first && !args.first.start_with?("-")
        command = args.first
      end

      options_parser = OptionParser.new do |opts|
        opts.on("--path [PATH]") do |path|
          raise OptionParser::InvalidOption unless ["fetch", "preview", "publish"].include? command
          options[:path] = path
        end

        opts.on("--output [PATH]") do |path|
          raise OptionParser::InvalidOption unless ["fetch", "preview"].include? command
          options[:output] = path
        end

        opts.on("--api_host API_HOST") do |api_host|
          raise OptionParser::InvalidOption unless ["fetch", "preview", "publish"].include? command
          options[:api_host] = api_host
        end

        opts.on("--api-name API_HOST") do |api_name|
          raise OptionParser::InvalidOption unless ["fetch", "publish"].include? command
          options[:api_name] = api_name
        end

        opts.on("--browser BROWSER") do |browser|
          raise OptionParser::InvalidOption if command != "preview"
          options[:browser] = browser
        end

        opts.on("--server") do
          raise OptionParser::InvalidOption if command != "preview"
          options[:server] = true
        end

        opts.on("--port [PORT]") do |port|
          raise OptionParser::InvalidOption unless ["fetch", "preview", "publish"].include? command
          options[:port] = port
        end

        opts.on('-v', '--version') do
          raise OptionParser::InvalidOption if command
          command = :version
        end

        opts.on( '-h', '--help') do
          raise OptionParser::InvalidOption if command
          command = :help
        end
      end

      options_parser.parse!
      options[:command] = command || :help
      options

    rescue OptionParser::InvalidOption => e
      puts e
      puts Apiary::Command::Help.banner
      exit 1
    end

  end
end
