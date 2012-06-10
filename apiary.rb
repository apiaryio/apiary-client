require 'rubygems'

require 'launchy'
require 'rest_client'

headers  = {:accept => "text/html",:content_type => "text/plain"}
response = RestClient.post "http://api.apiary.io/blueprint/generate", IO.read('apiary.apib'), headers

aFile = File.new("/tmp/apiarypreview.html", "w")
aFile.write(response)
aFile.close

Launchy.open("file:///tmp/apiarypreview.html")
