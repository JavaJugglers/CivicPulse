Feature: create and view events

Background:
  Given I create a state and county
  Given I am on the representatives search page
  When I go to "login"
  When I press "GitHub login"
  Given I am on the events page

Scenario: create a new event
  Then I should see "Events"
  And I follow "Add New Event"
  Then I should see "Name:"
  And I fill in "event_name" with "chips 10.5"
  And I fill in "event_description" with "trying to get 85 percent"
  And I press "save"
  Then I should see "County must exist"
  Then I follow "View all events"
  And I should see "Reset Filters"
  
Scenario: view a new object
  Then I create a new event
  Given I am on the events page
  Then I should see "trying to get 85 percent coverage"
  Then I follow "view 1"
  And I should see "Event Details"
  And I should see "chips 10.5"
  Then I follow "Edit"
  Then I should see "Edit event"
  Then I fill in "event_description" with "I still haven't gotten 85 percent"
  And I press "Save"
  Then I should see "Event was successfully updated."
  Then I should see "I still haven't gotten 85 percent"
  Then I select "example_state" from "actionmap-events-filter-state"
  And I follow "Reset Filters"
  Then I should see "Select a state"

Scenario: testing buttons
  Then I create a new event
  Given I am on the events page
  Then I should see "trying to get 85 percent coverage"
  Then I follow "view 1"
  Then I follow "view all"
  Then I should see "Events"
  Then I should see "chips 10.5"