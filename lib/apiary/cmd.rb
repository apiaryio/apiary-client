# Base skeleton taken from Heroku base command,
# https://github.com/heroku/heroku/blob/master/lib/heroku/command.rb
# (c) Heroku and contributors

module Apiary
  module Command
    class CommandFailed  < RuntimeError; end

    def self.commands
      @@commands ||= {}
    end

    def self.command_aliases
      @@command_aliases ||= {}
    end

    def self.load
      Dir[File.join(File.dirname(__FILE__), "commands", "*.rb")].each do |file|
        require file
      end
    end

    def self.parse(cmd)
      commands[cmd] || commands[command_aliases[cmd]]
    end

    def self.prepare_run(cmd, args=[])
      command = parse(cmd)

      unless command
        if %w( -v --version ).include?(cmd)
          command = parse('version')
        else
          error([
            "`#{cmd}` is not an apiary command.",
          ].compact.join("\n"))
        end
      end

      # add args, opts
      [ command[:klass].new(), command[:method] ]
    end

    def self.register_command(command)
      commands[command[:command]] = command
    end


	def self.run(cmd, arguments=[])
      object, method = prepare_run(cmd, arguments.dup)
      object.send(method)
	rescue CommandFailed => e
      error e.message
    rescue OptionParser::ParseError
      commands[cmd] ? run("help", [cmd]) : run("help")
    end

    def self.error(message)
      $stderr.puts(message)
      exit(1)
    end
  end
end
