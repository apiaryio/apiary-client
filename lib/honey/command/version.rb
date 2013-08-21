# encoding: utf-8
module Honey
  module Command
    # Display version
    class Version

      def self.execute(options)
        puts Honey::VERSION
      end

    end
 end
end
