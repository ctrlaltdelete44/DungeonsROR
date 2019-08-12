# frozen_string_literal: true

require 'test_helper'

class AccountsSignupTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get new_account_registration_path
    assert_no_difference 'Account.count' do
      post account_registration_path, params: { account: { email: 'user@invalid',
                                                           password: 'egg',
                                                           password_confirmation: 'boy' } }
    end

    assert_select 'div#error_explanation', count: 1
    assert_select 'li', "Password confirmation doesn't match Password"
    assert_select 'li', 'Password is too short (minimum is 8 characters)'
    assert_select 'li', 'Email is invalid'
  end

  test 'valid signup information with activation' do
    get new_account_registration_path
    assert_difference 'Account.count', 1 do
      post account_registration_path, params: { account: { email: 'user@example.com',
                                                           password: 'password',
                                                           password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    account = assigns(:account)
    assert_not account.confirmed?
    # try to log in before activation
    sign_in account
    # redirects to root, then back to login
    assert_redirected_to root_url
    follow_redirect!
    assert_redirected_to new_account_session_path
    follow_redirect!
    assert_select 'p.alert-msg', 'You have to confirm your email address before continuing.'

    # activation managed by devise
  end
end
