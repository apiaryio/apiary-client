# encoding: utf-8
module Apiary
  module Command
    class Runner

      def self.run(cmd, options)
        Apiary::Command.const_get(cmd.capitalize).send(:execute, options)
      end

    end
  end
end
