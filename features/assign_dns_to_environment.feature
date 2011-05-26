Feature: Assign DNS to environment IP address via DNSimple
  I want to assign DNS record to an AppCloud environment IP address

  Background:
    Given I have setup my engineyard email/password for API access
    And I have "two apps" in AppCloud
    And I have setup my fog credentials for "DNSimple"
    And I have DNS domain "myapp.com" with provider "DNSimple"
    
  Scenario: Assign new DNS A Record to an environment
    When I run local executable "ey-dns" with arguments "assign myapp.com --account main --environment giblets"
    Then I should see exactly
      """
      Fetching AppCloud environment information...
      AppCloud environment main/giblets has IP 127.0.0.0
      
      Searching for myapp.com amongst your DNS providers...
      Found myapp.com in DNSimple account
      
      Assigning myapp.com --> 127.0.0.0 (main/giblets)
      Created A record for myapp.com
      Assigning www.myapp.com --> 127.0.0.0 (main/giblets)
      Created A record for www.myapp.com
      Complete!
      
      """
      # Found 2 records for myapp.com
      #   .myapp.com (A)-> 127.0.0.0 (ttl:60, id:\d+)
      #   www.myapp.com (A)-> 127.0.0.0 (ttl:60, id:\d+)
  
  Scenario: Resssign DNS A Record to an environment
    When I run local executable "ey-dns" with arguments "assign myapp.com --account main --environment giblets"
    And I run local executable "ey-dns" with arguments "assign myapp.com --account main --environment giblets --force"
    Then I should see matching
      """
      Fetching AppCloud environment information...
      AppCloud environment main/giblets has IP 127.0.0.0
      
      Searching for myapp.com amongst your DNS providers...
      Found myapp.com in DNSimple account
      
      Deleted myapp.com
      Assigning myapp.com --> 127.0.0.0 (main/giblets)
      Created A record for myapp.com
      Deleted www.myapp.com
      Assigning www.myapp.com --> 127.0.0.0 (main/giblets)
      Created A record for www.myapp.com
      Complete!
      
      """
      # Found 2 records for myapp.com
      #   .myapp.com (A)-> 127.0.0.0 (ttl:60, id:\d+)
      #   www.myapp.com (A)-> 127.0.0.0 (ttl:60, id:\d+)

  Scenario: Assign subdomain A Record to an environment
    When I run local executable "ey-dns" with arguments "assign myapp.com staging --account main --environment giblets"
    Then I should see exactly
      """
      Fetching AppCloud environment information...
      AppCloud environment main/giblets has IP 127.0.0.0
      
      Searching for myapp.com amongst your DNS providers...
      Found myapp.com in DNSimple account
      
      Assigning staging.myapp.com --> 127.0.0.0 (main/giblets)
      Created A record for staging.myapp.com
      Complete!
      
      """
      # Found 1 records for myapp.com
      #   staging.myapp.com (A)-> 127.0.0.0 (ttl:60, id:\d+)

  
  
