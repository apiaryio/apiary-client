Feature: Show API documentation in specified browser

  # This is integration testing you have to set APIARY_API_KEY
  Scenario: Write generated HTML into specified file

    When I run `apiary preview --path apiary.apib --output=test.html`
    Then a file named "test.html" should exist
