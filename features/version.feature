Feature: Version of Apiary client

  Scenario: Print the semantic version of Apiary client

    # Note the output should be a semantic version (semver.org)
    # The matching regex was taken from https://github.com/isaacs/node-semver/issues/32#issue-15023919

    When I run `apiary version`
    Then the output should match /^([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+[0-9A-Za-z-]+)?$/
    And the exit status should be 0
