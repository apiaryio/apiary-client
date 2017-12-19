Feature: Styleguide apiary.apib on docs.API_NAME.apiary.io

  # This is integration testing you have to set APIARY_API_KEY
  @needs_apiary_api_key
  Scenario: Styleguide validation - pass

    When I run `apiary  styleguide --functions=../../features/support --rules=../../features/support --add=../../features/support --full_report`
    Then the output should match /(PASSED)/
    And the exit status should be 0

  @needs_apiary_api_key
  Scenario: Styleguide validation - fail

    When I run `apiary  styleguide --functions=../../features/support/functions-fail.js --rules=../../features/support --add=../../features/support --full_report`
    Then the output should match /(FAILED)/
    And the exit status should be 1

  # This is integration testing you have to set APIARY_API_KEY
  @needs_apiary_api_key
  Scenario: Styleguide fetch

    When I run `apiary  styleguide --fetch`
    Then the output should match /(has beed succesfully created)/
    And  the exit status should be 0


