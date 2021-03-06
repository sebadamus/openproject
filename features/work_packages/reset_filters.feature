#-- copyright
# OpenProject is a project management system.
#
# Copyright (C) 2012-2013 the OpenProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

Feature: Resetting filteres on work packages
  Background:
    Given there is a project named "project1"
    And the project "project1" has the following types:
      | name  | position |
      | Bug   | 1        |
      | Other | 2        |
    And there is a role "manager"
    And the role "manager" may have the following rights:
      | view_work_packages |
    And there is 1 user with:
      | Login        | manager   |
    And the user "manager" is a "manager" in the project "project1"
    Given the user "manager" has 1 issue with the following:
      | subject | Some issue |
      | type    | Bug        |
    And I am already admin
    And I am on the work package index page of the project called "project1"

    When I select "Type" from "Add filter"
     And I select "Other" from "values_type_id"
     And I follow "Apply"

    Then I should not see "Some issue"
     And I should see "No data to display"

  @javascript
  Scenario: Clearing filters via the menu
    When I toggle the "Work packages" submenu
     And I follow "View all work packages"

    Then I should be on the work package index page of the project called "project1"
     And I should see "Some issue"

  @javascript
  Scenario: Clearing filters via the filter buttons
    When I follow "Clear"

    Then I should be on the work package index page of the project called "project1"
     And I should see "Some issue"
