Feature: Migration
  In order to reduce cost of migrating from Heroku to AppCloud
  As a developer
  I want to migrate as much of my Heroku-hosted application to AppCloud

  Scenario: Migrate a simple app
    Given I have setup my SSH keys
    And I clone the application "git@github.com:engineyard/heroku2ey-simple-app.git" as "simple-app"

    And I have setup my Heroku credentials
    And I have a Heroku application "heroku2ey-simple-app"
    And it has production data
    When I visit the application at "heroku2ey-simple-app.heroku.com"
    Then I should see table
      | People |
      | Dr Nic |
      | Danish |

    Given I have setup my AppCloud credentials
    Then I have an AppCloud account "heroku2ey" with environment "heroku2eysimpleapp_production"
    And I reset the AppCloud application "heroku2eysimpleapp" database
    When I visit the application at "ec2-50-17-248-148.compute-1.amazonaws.com"
    Then I should see table
      | People |

    When I run local executable "heroku2ey" with arguments "migrate . --account heroku2ey --environment heroku2eysimpleapp_production"
    Then I should see "Migration complete!"
    When I visit the application at "ec2-50-17-248-148.compute-1.amazonaws.com"
    Then I should see table
      | People |
      | Dr Nic |
      | Danish |
    And port "3306" on "ec2-50-17-248-148.compute-1.amazonaws.com" should be closed
  
  Scenario: Fail if application isn't on Heroku
    Given I clone the application "git@github.com:engineyard/heroku2ey-simple-app.git" as "simple-app"
    When I run local executable "heroku2ey" with arguments "migrate . --account heroku2ey --environment heroku2eysimpleapp_production"
    Then I should see
      """
      'heroku2ey migrate' is for migrating heroku applications.
      """
  
  
  
