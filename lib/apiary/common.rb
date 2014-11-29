# encoding: utf-8

module Apiary
    # Common function used in commands
    class Common

      attr_accessor :error_message

      def initialize()
      end

      def validate_apib_file(apib_file)
        unless File.exist?(apib_file)
          raise "Apiary definition file hasn't been found: #{apib_file.inspect}"
        end
        File.read(apib_file)
      end

    end
end
