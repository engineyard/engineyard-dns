Feature: Assign DNS to environment IP address
  I want to assign DNS record to an AppCloud environment IP address

  Background:
    Given I have setup my engineyard email/password for API access
    And I have "two apps" in AppCloud
  
  Scenario: Assign new DNS A Record to an environment via fog to DNSimple
    Given I have setup my fog credentials for "DNSimple"
    And I have DNS domain "myapp.com" with provider "DNSimple"
    When I run local executable "ey-dns" with arguments "assign myapp.com --account main --environment giblets"
    Then I should see exactly
      """
      Fetching AppCloud environment information...
      Found AppCloud environment giblets on account main with IP 174.129.7.113
      
      Searching for myapp.com amongst your DNS providers...
      Found myapp.com in DNSimple account
      
      Assigning myapp.com --> 174.129.7.113 (main/giblets)
      Created A record for myapp.com
      Assigning www.myapp.com --> 174.129.7.113 (main/giblets)
      Created A record for www.myapp.com
      Complete!
      
      """
