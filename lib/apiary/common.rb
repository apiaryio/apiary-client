# encoding: utf-8
require 'redsnow'

module Apiary
    # Common function used in commands
    class Common

      def initialize()
      end

      def validate_apib_file(apib_file)
        unless File.exist?(apib_file)
          raise "Apiary definition file hasn't been found: #{apib_file.inspect}"
        end
        return true
      end

    end
end
