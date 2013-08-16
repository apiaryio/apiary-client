# encoding: utf-8
module Apiary
  module Okapi
    class Help
      
      def self.show
        banner
        options
      end

      def self.banner
        puts "\nUsage: okapi [options]"
        puts "Try 'okapi help' for more information."
      end

      def self.options
        puts "\nCurrently available okapi options are:\n\n"

        puts "\t-b, --blueprint             path to the blueprint (default: " + BLUEPRINT_PATH + " )"
        puts "\t-t, --test_spec             path to the test specification (default: " + TEST_SPEC_PATHS + " )"
        #puts "\t-o, --output                output format (default: " + OUTPUT + ")"
        puts "\t-u, --test_url              url to test (default: " + TEST_URL + ")"
        puts "\t-a, --apiary                apiary url  (default: " + APIARY_URL + ")"
        puts "\t-s, --config                config file  (default: " + CONFIG_PATH + ")"
        puts "\t-p, --params                prints used parameters"
        puts "\n"
        puts "\thelp                        Show this help"
        puts "\n"
      end

      def self.okapi
        puts File.read(File.dirname(__FILE__) + '/okapi')
      end
    end
  end
end
