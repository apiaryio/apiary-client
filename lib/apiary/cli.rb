require 'optparse'

class Apiary::CLI

  attr_reader   :args
  attr_reader   :options

  def initialize(args=[])
    @args = args
    @options = {}
    @exit_status = true
  end

  def self.run(args)
    new(args).run
  end

  def run
    @args << '-h' if @args.empty?
    parse_options!(@args)
    if @options[:server]
      Apiary::Commands::Preview.server(@options)
    else
      Apiary::Commands::Preview.show(@options)
    end
  end

  def parse_options!(args)
    options_parser = OptionParser.new do |opts|
      opts.banner = "\nUsage: apiary command [options]\n\n"

      opts.on("--preview [PATH]", 'Show API documentation in a browser') do |path|
        @options[:apib_path] = path
      end

      opts.on("--api_host API_HOST", 'Specify API hostname') do |api_host|
        @options[:api_host] = api_host
      end

      opts.on("--server", 'Start a web server on port 8080') do
        @options[:server] = true
      end

      opts.on('-v', '--version', 'Display the version') do
        puts Apiary::VERSION
      end

      opts.on( '-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
   end
   @args = options_parser.parse!(@args)
  end

end
