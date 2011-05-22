Feature: Assign DNS to environment IP address
  I want to assign DNS record to an AppCloud environment IP address

  Background:
    Given I have setup my engineyard email/password for API access
    And I have "two apps" in AppCloud
    And I have setup my dnsimple credentials
    And I have DNSimple domain "myapp.com"
    
  Scenario: Assign DNS A Record to an environment
    When I run local executable "ey-dnsimple" with arguments "assign myapp.com --account main --environment giblets"
    Then I should see matching
      """
      Fetching AppCloud environment information...
      Found environment giblets on account main with IP 174.129.7.113
      Assigning myapp.com --> 174.129.7.113 (main/giblets)
      Created A record for myapp.com (id:\d+)
      Assigning www.myapp.com --> 174.129.7.113 (main/giblets)
      Created A record for myapp.com (id:\d+)
      Complete!
      Found 2 records for myapp.com
      	.myapp.com (A)-> 174.129.7.113 (ttl:60, id:\d+)
      	www.myapp.com (A)-> 174.129.7.113 (ttl:60, id:\d+)
      """
  
  
  
