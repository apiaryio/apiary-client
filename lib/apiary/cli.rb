require 'optparse'

class Apiary::CLI

  attr_reader   :args
  attr_reader   :options

  def initialize(args=[])
    @args = args
    @exit_status = true
  end

  def self.run(args)
    new(args).run
  end

  def run
    @args << '-h' if @args.empty?
    parse_options!(@args)
  end

  def parse_options!(args)
    options_parser = OptionParser.new do |opts|
      opts.banner = "\nUsage: apiary command [options]\n\n"

      opts.on("--preview", 'Show API documentation in a browser') {}
      opts.on("--server", 'Start a web server on port 8080')      { @options[:port] = 8080 }
      opts.on('-v', '--version', 'Display the version')           { puts Apiary::VERSION }
      opts.on( '-h', '--help', 'Display this screen' )            { puts opts; exit }
   end
   @args = options_parser.parse!(@args)
  end

end
