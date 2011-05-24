Feature: Assign DNS to environment IP address
  I want to assign DNS record to an AppCloud environment IP address

  Background:
    Given I have setup my engineyard email/password for API access
    And I have "two apps" in AppCloud
  
  Scenario Outline: Assign new DNS A Record to an environment via fog
    Given I have setup my fog credentials for "<provider>"
    And I have DNS domain "myapp.com" with provider "<provider>"
    When I run local executable "ey-dns" with arguments "assign myapp.com --account main --environment giblets"
    Then I should see matching
      """
      Fetching AppCloud environment information...
      Found AppCloud environment giblets on account main with IP 174.129.7.113
      
      Searching for myapp.com amongst your DNS providers...
      Found myapp.com in \w+ account ossgrants\+dns@engineyard.com
      
      Assigning myapp.com --> 174.129.7.113 (main/giblets)
      Created A record for myapp.com
      Assigning www.myapp.com --> 174.129.7.113 (main/giblets)
      Created A record for www.myapp.com
      Complete!
      """

  Scenarios: all fog DNS providers
    | provider |
    | DNSimple |
    
  
  
  