# encoding: utf-8
require 'optparse'
require 'yaml'

module Honey
  module Okapi
    class CLI

      def initialize(args)
        case args.first
          when 'help'
            Honey::Okapi::Help.show
            exit 0
          when 'okapi'
            Honey::Okapi::Help.okapi
            exit 0
          else
            parse_options!(args)
            parse_config
            @options[:blueprint]   ||= BLUEPRINT_PATH
            @options[:test_spec]   ||= TEST_SPEC_PATHS
            @options[:output]      ||= OUTPUT
            @options[:test_url]    ||= TEST_URL
            @options[:apiary_url]  ||= APIARY_URL

            @options[:test_spec] ||= TEST_SPEC_PATHS.gsub(' ','').split(',')

            if @options[:params]
              puts "running with :"
              p @options
              puts "\n"
            end

            exit run
        end    
      end

      def run
        pass = true
        @options[:test_spec].each { |spec|
          pass = Honey::Okapi::Test.new(@options[:blueprint], spec, @options[:test_url], @options[:output], @options[:apiary_url]).run()
          }
        if pass
          0
        else
          1
        end
      end

      def parse_config
        begin
          if tests = YAML.load_file(@options[:config_path])['tests']
            @options[:test_url] ||= tests['host'] if tests['host']
            @options[:test_spec] ||= tests['specs'] if tests['specs']
          end
        rescue Errno::ENOENT  => e          
          puts "Config file (#{@options[:config_path]}) not accessible ... skiping"
          puts "\n"
        rescue Exception => e
          puts "Config file (#{@options[:config_path]}) loading problem :#{e}"
          puts "\n"
          exit 1
        end
      end

      def parse_options!(args)
        @options = {}
        options_parser = OptionParser.new do |opts|
          opts.on("-c", "--config CONFIG",
                  "path config file (default: " + CONFIG_PATH + " )") do |config|
            @options[:config_path] = config
          end

          opts.on("-b", "--blueprint BLUEPRINT",
                  "path to the blueprint (default: " + BLUEPRINT_PATH + " )") do |blueprint|            
            @options[:blueprint] = blueprint
          end

          opts.on("-t","--test_spec TEST_SPEC",
                  "comma separated paths to the test specifications (default: " + TEST_SPEC_PATHS + " )") do |test_spec|
            @options[:test_spec] = test_spec
          end

          opts.on("-o","--output OUTPUT",
                  "output format (default" + OUTPUT + ")") do |output|
            @options[:output] = output
          end

          opts.on("-u","--test_url TEST_URL",
                  "url to test (default" + TEST_URL + ")") do |test_url|
            @options[:test_url] = test_url
          end

          opts.on("-a","--apiary APIARY",
                  "apiary url  (default" + APIARY_URL + ")") do |apiary|
            @options[:apiary_url] = apiary
          end

          opts.on("-p","--params [PARAMS]",
                  "show parameters" ) do |params|
            @options[:params] = true
          end          
        end

        options_parser.parse!

        @options[:config_path]  ||= CONFIG_PATH
        @options[:test_spec] = @options[:test_spec].gsub(' ','').split(',') if @options[:test_spec]

        @options

      rescue OptionParser::InvalidOption => e
        puts "\n"
        puts e
        Honey::Okapi::Help.banner
        puts "\n"
        exit 1
      end

    end
  end
end
