Feature: Styleguide apiary.apib on docs.API_NAME.apiary.io

  # This is integration testing you have to set APIARY_API_KEY
  @needs_apiary_api_key
  Scenario: Styleguide validation

    When I run `apiary  styleguide --functions=../../features/support --rules=../../features/support --add=../../features/support --full_report`
    Then the output should match /(\"validatorError\": false)/
    And the exit status should be 0

  # This is integration testing you have to set APIARY_API_KEY
  @needs_apiary_api_key
  Scenario: Styleguide fetch

    When I run `apiary  styleguide --fetch`
    Then the output should match /(has beed succesfully created)/
    And  the exit status should be 0


