Feature: Missing credentials
  I want to be educated/helped when I don't have credentials setup correctly

  Scenario: Show example .fog file if credentials are missing
    Given I have not setup my fog credentials
    When I run local executable "ey-dns" with arguments "domains"
    Then I should see exactly
      """
      ERROR: Missing credentials for DNS providers.
      An example ~/.fog credentials file has been created for you.
      
      """
    And file "~/.fog" is created
  
  
  
  
