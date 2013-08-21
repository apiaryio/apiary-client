# encoding: utf-8
module Honey
  module Command
    # Run commands
    class Runner

      def self.run(cmd, options)
        Honey::Command.const_get(cmd.to_s.capitalize).send(:execute, options)
      end

    end
  end
end
