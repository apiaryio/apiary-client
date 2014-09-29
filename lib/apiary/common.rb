# encoding: utf-8
require 'redsnow'

module Apiary
    # Common function used in commands
    class Common

      attr_accessor :error_message

      def initialize()
      end

      def validate_blueprint(code)
        result = RedSnow.parse(code)
        if result.error[:code] == 0
          @error_message = nil
          return true
        else
          @error_message = result.error[:message]
          return false
        end
      end

      def validate_apib_file(apib_file)
        unless File.exist?(apib_file)
          raise "Apiary definition file hasn't been found: #{apib_file.inspect}"
        end
        return true
      end

    end
end
