require 'spec_helper'

describe Apiary::Command::Fetch do

  it 'pass command without params' do
    opts = {}
    command = Apiary::Command::Fetch.new(opts) 
    expect { command.fetch_from_apiary }.to raise_error('Please provide an api-name option (subdomain part from your http://docs.<api-name>.apiary.io/)')        
  end

  it 'pass command only with api_name' do
    opts = {
        :api_name => 'test_api'
    }
    command = Apiary::Command::Fetch.new(opts) 
    expect { command.fetch_from_apiary }.to raise_error('API key must be provided through environment variable APIARY_API_KEY. Please go to https://login.apiary.io/tokens to obtain it.')        
  end

  it 'check request for fetch to apiary' do

    API_NAME = 'test_api'

    opts = {
        :api_name => API_NAME,
        :api_key => '1234567890'
    }
    command = Apiary::Command::Fetch.new(opts) 
    
    BODY_EXAMPLE = '{
  "error": false,
  "message": "",
  "code": "FORMAT: 1A\nHOST: http://www.testing.com\n\n# Notes API test 123\nNotes API is a *short texts saving* service similar to its physical paper presence on your table.\n\n# Group Notes\nNotes related resources of the **Notes API**\n\n## Notes Collection [/notes]\n### List all Notes [GET]\n+ Response 200 (application/json)\n\n        [{\n          \"id\": 1, \"title\": \"Jogging in park\"\n        }, {\n          \"id\": 2, \"title\": \"Pick-up posters from post-office\"\n        }]\n\n### Create a Note [POST]\n+ Request (application/json)\n\n        { \"title\": \"Buy cheese and bread for breakfast.\" }\n\n+ Response 201 (application/json)\n\n        { \"id\": 3, \"title\": \"Buy cheese and bread for breakfast.\" }\n\n## Note [/notes/{id}]\nA single Note object with all its details\n\n+ Parameters\n    + id (required, number, `1`) ... Numeric `id` of the Note to perform action with. Has example value.\n\n### Retrieve a Note [GET]\n+ Response 200 (application/json)\n\n    + Header\n\n            X-My-Header: The Value\n\n    + Body\n\n            { \"id\": 2, \"title\": \"Pick-up posters from post-office\" }\n\n### Remove a Note [DELETE]\n+ Response 204\n"
}'    

    BLUEPRINT_EXAMPLE = %Q{FORMAT: 1A
HOST: http://www.testing.com

# Notes API test 123
Notes API is a *short texts saving* service similar to its physical paper presence on your table.

# Group Notes
Notes related resources of the **Notes API**

## Notes Collection [/notes]
### List all Notes [GET]
+ Response 200 (application/json)

        [{
          "id": 1, "title": "Jogging in park"
        }, {
          "id": 2, "title": "Pick-up posters from post-office"
        }]

### Create a Note [POST]
+ Request (application/json)

        { "title": "Buy cheese and bread for breakfast." }

+ Response 201 (application/json)

        { "id": 3, "title": "Buy cheese and bread for breakfast." }

## Note [/notes/{id}]
A single Note object with all its details

+ Parameters
    + id (required, number, `1`) ... Numeric `id` of the Note to perform action with. Has example value.

### Retrieve a Note [GET]
+ Response 200 (application/json)

    + Header

            X-My-Header: The Value

    + Body

            { "id": 2, "title": "Pick-up posters from post-office" }

### Remove a Note [DELETE]
+ Response 204
}

    stub_request(:get, "https://api.apiary.io/blueprint/get/#{API_NAME}").to_return(:status => 200, :body => BODY_EXAMPLE, :headers => { 'Content-Type' => 'text/plain' })
    command.fetch_from_apiary.should eq(BLUEPRINT_EXAMPLE) 
  end
end
