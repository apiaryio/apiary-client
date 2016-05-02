Feature: Show API documentation in specified browser

  # This is integration testing you have to set APIARY_API_KEY
  @needs_apiary_api_key
  Scenario: Write generated HTML into specified file

    When I run `apiary preview --path ../../spec/fixtures/apiary.apib --output=test.html`
    Then a file named "test.html" should exist
