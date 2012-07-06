require "apiary/commands/base"

# Display preview of local blueprint file
module Apiary
  module Command
    class Preview < Apiary::Command::Base
      # Preview.
      #
      # Launch web browser and display preview of local blueprint file
      def index
        api_server = ENV.fetch("APIARY_API_HOST") { "api.apiary.io" }

        require "launchy"
        require "rest_client"

        headers  = {:accept => "text/html", :content_type => "text/plain"}
        response = RestClient.post "https://#{api_server}/blueprint/generate", IO.read("apiary.apib"), headers

        file = File.new("/tmp/apiarypreview.html", "w")
        file.write(response)
        file.close

        Launchy.open("file:///tmp/apiarypreview.html")
      end
    end
  end
end
