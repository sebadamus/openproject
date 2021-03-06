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

Feature: Paginated work packages index list

  Background:
    Given we paginate after 3 items
    And there is 1 project with the following:
      | identifier | project1 |
      | name       | project1 |
    And the project "project1" has the following types:
      | name | position |
      | Bug  |     1    |
    And there is 1 user with the following:
      | login      | bob      |
    And there is a role "member"
    And the role "member" may have the following rights:
      | view_work_packages |
    And the user "bob" is a "member" in the project "project1"
    And the user "bob" has 4 issues with the following:
      | subject    | Issuesubject |
    And I am already logged in as "bob"

  Scenario: Pagination within a project
    When I go to the work packages index page of the project "project1"
    Then I should see 3 issues
    When I follow "2" within ".pagination"
    Then I should be on the work packages index page of the project "project1"
    And I should see 1 issue

  Scenario: Pagination outside a project
    When I go to the global index page of work packages
    Then I should see 3 issues
    When I follow "2" within ".pagination"
    Then I should be on the global index page of work packages
    And I should see 1 issue

  Scenario: Changing issues per page
    When I go to the work packages index page of the project "project1"
    Then I follow "2" within ".pagination"
    Then I should see 1 issue
    Then I follow "100" within ".per_page_options"
    Then I should see 4 issues
