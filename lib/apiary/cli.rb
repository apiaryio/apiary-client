require "apiary"
require "apiary/cmd"

class Apiary::CLI
  def self.start(*args)
    command = args.shift.strip rescue "help"
    Apiary::Command.load
    Apiary::Command.run(command, args)
  end
end
