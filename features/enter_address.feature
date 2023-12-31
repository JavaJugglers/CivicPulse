Feature: test representatives

Background: on the search page
  Given I am on the representatives search page

Scenario: Try to find representative
  And I fill in "address" with "San Francisco"
  And I press "search button"
  And I follow "Joseph R. Biden link"
  And I should see "Address: 1600 Pennsylvania Avenue Northwest, Washington, DC 20500"
  Then I follow "Back"
  And I should see "Search for a Representative"

Scenario: Click on the "All Representatives" button
  And I fill in "address" with "San Francisco"
  And I press "search button"
  And I follow "Joseph R. Biden button"
  And I follow "All Representatives"
  Then I should see "Search for a Representative"

Scenario: Entering an invalid address doesn't error, promps you to reenter
  And I fill in "address" with "Joseph R. Biden"
  And I press "search button"
  Then I should see "Please enter a valid address."
