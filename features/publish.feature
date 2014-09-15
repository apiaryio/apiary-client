Feature: Publish apiary.apib on docs.API_NAME.apiary.io

  # This is integration testing you have to set APIARY_API_KEY
  Scenario: Publish apiary.apib on docs.API_NAME.apiary.io

    When I run `apiary publish --path=apiary.apib --api-name 1111apiaryclienttest`
    Then the exit status should be 1
