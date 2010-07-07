Feature: Use Factory Girl instead of Fixtures for generators

  Scenario: generate a rails 3 application and use factory definitions
    When I generate a new rails application
    And I save the following as "Gemfile"
      """
      source "http://rubygems.org"
      gem 'rails', '3.0.0.beta4'
      gem 'sqlite3-ruby', :require => 'sqlite3'
      gem 'factory_girl_rails', :path => '../../'
      """
    When I run "bundle lock"
    And I save the following as "config/application.rb"
      """
      require File.expand_path('../boot', __FILE__)
      require 'rails/all'
      Bundler.require(:default, Rails.env) if defined?(Bundler)
      module Testapp
        class Application < Rails::Application
          config.generators do |g|
            g.test_framework :test_unit, :fixture => false
            g.fixture_replacement :factory_girl
          end
        end
      end
      """
    When I run "rails g model User name:string"
    And I run "rake db:migrate"
    And I save the following as "test/unit/user_test.rb"
      """
      require 'test_helper'

      class UserTest < ActiveSupport::TestCase
        test "use factory" do
          user = Factory(:user)
          assert_equal 'MyString', user.name
        end
      end
      """
    When I run "rails g factory_girl User name:string"
    And I run "rake test"
    Then I should see "1 tests, 1 assertions, 0 failures, 0 errors"
