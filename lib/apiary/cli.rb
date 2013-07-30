# encoding: utf-8
require 'optparse'
module Apiary
  class CLI

    attr_reader :command

    def initialize(args)
      options = parse_options!(args)
      run(args, options)
    end

    def run(args, options)
      command = args.first || :help
      command = @command if @command
      Apiary::Command::Runner.run(command, options)
    end

    def parse_options!(args)
      @command = nil
      options = {}
      options_parser = OptionParser.new do |opts|
        opts.on("--path [PATH]") do |path|
          options[:path] = path
        end

        opts.on("--output [PATH]") do |path|
          options[:output]  = path
        end

        opts.on("--api_host API_HOST") do |api_host|
          options[:api_host] = api_host
        end

        opts.on("--browser BROWSER") do |browser|
          options[:browser] = browser
        end

        opts.on("--server") do
          options[:server] = true
        end

        opts.on("--port [PORT]") do |port|
          options[:port] = port
        end

        opts.on('-v', '--version') do
          @command = :version
        end

        opts.on( '-h', '--help') do
          @command = :help
        end
      end

      options_parser.parse!
      options

    rescue OptionParser::InvalidOption => e
      puts e
      puts Apiary::Command::Help.banner
      exit 1
    end

  end
end
