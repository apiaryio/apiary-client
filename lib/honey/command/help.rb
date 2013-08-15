# encoding: utf-8
module Honey
  module Command
    # Display help
    class Help

      def self.execute(options)
        banner
        commands
      end

      def self.banner
        puts "\nUsage: apiary command [options]"
        puts "Try 'apiary help' for more information."
      end

      def self.commands
        puts "\nCurrently available apiary commands are:\n\n"
        puts "\tpreview                                     Show API documentation in default browser"
        puts "\tpreview --browser [chrome|safari|firefox]   Show API documentation in specified browser"
        puts "\tpreview --path [PATH]                       Specify path to blueprint file"
        puts "\tpreview --api_host [HOST]                   Specify apiary host"
        puts "\tpreview --server                            Start standalone web server on port 8080"
        puts "\tpreview --server --port [PORT]              Start standalone web server on specified port"
        puts "\tpublish --api-name [API_NAME]               Publish apiary.apib on docs.API_NAME.apiary.io"
        puts "\tokapi help                                  Show okapi testing tool help"
        puts "\n"
        puts "\thelp                                        Show this help"
        puts "\n"
        puts "\tversion                                     Show version"
        puts "\n"
      end

    end
  end
end
