Feature: use the map to search for a representative

Background: on the Actionmap home page
  Given I am on the representatives search page

Scenario: get the representatives of San Francisco County California
  And I go to "California"
  And I go to "San Francisco"
  
Scenario: test search representatives button
  Given I am on the Actionmap home page
  And I follow "search button"
  And I should see "Search for a Representative"

Scenario: try to log in
  When I go to "login"
  When I press "GitHub login"
  When I go to "login"
  And I should see "github_test@example.com"
  And I should see "You are already logged in. Logout to switch accounts."
  Then I follow "Logout"
  And I should see "You have successfully logged out."
  Then I go to "login"
  And I press "Google login"
  And I go to "login"
  Then I should see "Google Test Developer" 
