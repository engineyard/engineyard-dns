Feature: Assign DNS to environment IP address via DNSimple
  I want to assign DNS record to an Engine Yard Cloud environment IP address

  Background:
    Given I have setup my engineyard email/password for API access
    And I have "two apps" in Engine Yard Cloud
    And I have setup my fog credentials for "DNSimple"
    And I have DNS domain "myapp.com" with provider "DNSimple"

  Scenario: Assign new DNS A Record to an environment
    When I run local executable "ey-dns" with arguments "assign myapp.com --account main --environment giblets"
    Then I should see exactly
      """
      Fetching Engine Yard Cloud environment information...
      Engine Yard Cloud environment main/giblets has IP 127.0.0.0

      Searching for myapp.com in your DNS providers...
      Found myapp.com in DNSimple account.

      Assigning myapp.com --> 127.0.0.0 (main/giblets)
      A record for myapp.com created.
      Assigning www.myapp.com --> 127.0.0.0 (main/giblets)
      A record for www.myapp.com created.
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
      Fetching Engine Yard Cloud environment information...
      Engine Yard Cloud environment main/giblets has IP 127.0.0.0

      Searching for myapp.com in your DNS providers...
      Found myapp.com in DNSimple account.

      myapp.com deleted.
      Assigning myapp.com --> 127.0.0.0 (main/giblets)
      A record for myapp.com created.
      www.myapp.com deleted.
      Assigning www.myapp.com --> 127.0.0.0 (main/giblets)
      A record for www.myapp.com created.
      Complete!

      """
      # Found 2 records for myapp.com
      #   .myapp.com (A)-> 127.0.0.0 (ttl:60, id:\d+)
      #   www.myapp.com (A)-> 127.0.0.0 (ttl:60, id:\d+)

  Scenario: Assign subdomain A Record to an environment
    When I run local executable "ey-dns" with arguments "assign staging.myapp.com --account main --environment giblets"
    Then I should see exactly
      """
      Fetching Engine Yard Cloud environment information...
      Engine Yard Cloud environment main/giblets has IP 127.0.0.0

      Searching for myapp.com in your DNS providers...
      Found myapp.com in DNSimple account.

      Assigning staging.myapp.com --> 127.0.0.0 (main/giblets)
      A record for staging.myapp.com created.
      Complete!

      """
      # Found 1 records for myapp.com
      #   staging.myapp.com (A)-> 127.0.0.0 (ttl:60, id:\d+)

