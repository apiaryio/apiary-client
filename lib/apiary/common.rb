# encoding: utf-8

module Apiary
    # Common function used in commands
    class Common

      attr_accessor :error_message

      def initialize()
      end

      def get_apib_file(apib_file)
        if validate_apib_file(apib_file)
          text_without_bom = nil
          File.open(apib_file, "r:bom|utf-8") { |file|
            text_without_bom = file.read
          }
          text_without_bom
        end
      end

      def validate_apib_file(apib_file)
        unless File.exist?(apib_file)
          raise "Apiary definition file hasn't been found: #{apib_file.inspect}"
        end
        true
      end
    end
end
