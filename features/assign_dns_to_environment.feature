Feature: Assign DNS to environment IP address
  I want to assign DNS record to an AppCloud environment IP address

  Background:
    Given I have setup my engineyard email/password for API access
    And I have "two apps" in AppCloud
    And I expect to create DNSimple::Record with attributes:
      | domain      | myapp.com     |
      | content     | 174.129.7.113 |
      | record_type | A             |
    
  Scenario: Assign DNS A Record to an environment
    When I run local executable "ey-dnsimple" with arguments "assign myapp.com --account main --environment giblets"
    Then I should see exactly
      """
      Assigning myapp.com --> 174.129.7.113 (main/giblets)
      Testing...
      Complete!
      
      """
  
  
  
