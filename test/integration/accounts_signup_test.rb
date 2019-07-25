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
      post new_account_registration_path, params: { account: { display_name: '',
                                             email: 'user@invalid',
                                             password: 'egg',
                                             password_confirmation: 'boy' } }
    end
    assert_template 'accounts/new'

    assert_select 'p.danger-msg', 'Email is invalid'
    assert_select 'p.danger-msg', "Password confirmation doesn't match Password"
    assert_select 'p.danger-msg', 'Password is too short (minimum is 8 characters)'
  end

  test 'valid signup information with activation' do
    get new_account_registration_path
    assert_difference 'Account.count', 1 do
      post new_account_registration_path, params: { account: { display_name: 'My display name',
                                               email: 'user@example.com',
                                               password: 'password',
                                               password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    account = assigns(:account)
    assert_not account.activated?
    # try to log in before activation
    sign_in account
    assert_not is_logged_in?

    # invalid activation link
    get edit_account_activation_path('invalid token', email: account.email)
    assert_not is_logged_in?

    # valid token, wrong Email
    get edit_account_activation_path(account.activation_token, email: 'wrong')
    assert_not is_logged_in?

    # valid activation
    get edit_account_activation_path(account.activation_token, email: account.email)
    follow_redirect!
    assert_template 'accounts/show'
    assert is_logged_in?
  end
end
