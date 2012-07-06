# encoding: utf-8

# Display preview of local blueprint file
Task.new(:preview) do |task|
  task.description = "Display preview of local blueprint file"

  task.boot do
    require "launchy"
    require "rest_client"
  end

  task.define do |api_server = "api.apiary.io"|
    headers  = {:accept => "text/html", :content_type => "text/plain"}
    response = RestClient.post "https://#{api_server}/blueprint/generate", IO.read("apiary.apib"), headers

    File.new("/tmp/apiarypreview.html", "w") do |file|
      file.write(response)
    end

    Launchy.open("file:///tmp/apiarypreview.html")
  end
end
