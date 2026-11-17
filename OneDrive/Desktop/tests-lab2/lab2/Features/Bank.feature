Feature: Add Customer

  Scenario: Successfully add a new customer
    Given I am on the banking website
    When I select "Login as Bank Manager" option
    And I click "Add Customer" tab
    And I enter First Name "John", Last Name "Doe", and Post Code "12345"
    And I click "Add Customer" submit button
    Then I should see alert message containing "Customer added successfully"
    And I accept the alert
    And I should close Chrome