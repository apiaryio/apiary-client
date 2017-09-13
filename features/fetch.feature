Feature: Fetch apiary.apib from API_NAME.apiary.io

  # This is integration testing you have to set APIARY_API_KEY
  @needs_apiary_api_key
  Scenario: Fetch apiary.apib from API_NAME.apiary.io

    When I run `apiary fetch --api-name=apiaryclitestingdonottouch`
    Then the output should contain the content of file "apiary.apib"
