Feature: List available domains
  I want to see the available domains I can associate with my AppCloud apps

  Scenario: Show domains without any records:
    Given I have setup my fog credentials for "DNSimple"
    And I have DNS domain "myapp.com" with provider "DNSimple"
    And I have DNS domain "myotherapp.com" with provider "DNSimple"
    When I run local executable "ey-dns" with arguments "domains"
    Then I should see exactly
      """
      DNSimple:
        myapp.com - 0 records
        myotherapp.com - 0 records
      
      """
    
  
