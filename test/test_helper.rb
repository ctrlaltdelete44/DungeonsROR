# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # returns boolean if whether current account matches given account
  def current_account?(account)
    account == current_account
  end
end
