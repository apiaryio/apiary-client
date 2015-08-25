Feature: Publish apiary.apib on docs.API_NAME.apiary.io

  # This is integration testing you have to set APIARY_API_KEY
  @needs_apiary_api_key
  Scenario: Publish apiary.apib on docs.API_NAME.apiary.io

    # expected to fail
    When I run `apiary publish --path=apiary.apib --api-name 1111apiaryclienttest`
    Then the exit status should be 1
