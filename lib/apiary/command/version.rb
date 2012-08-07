# encoding: utf-8
module Apiary
  module Command
    # Display version
    class Version

      def self.execute(options)
        puts Apiary::VERSION
      end

    end
 end
end
