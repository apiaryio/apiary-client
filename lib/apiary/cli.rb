class Apiary::Cli

  def initialize(args=[])
    @args = args
    @exit_status = true
  end

  def self.run(args)
    new(args).run
  end

  def parse_options!(args)
    options_parser = OptionsParser.new do |opts|
      opts.banner = "\nAvailable options:\n\n"

      opts.on("--preview")  {}
      opts.on("--server")   { @options[:port] = 8080 }
    end
    @args = options_parser.parse!(@args)
    puts("ARGS: #{@args.inspect}")
  end
end
