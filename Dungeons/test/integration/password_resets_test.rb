# frozen_string_literal: true

require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @account = accounts(:ferris)
  end

  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'

    # invalid email
    post password_resets_path, params: { password_reset: { email: '' } }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # valid email
    post password_resets_path, params: { password_reset: { email: @account.email } }
    assert_not_equal @account.reset_digest, @account.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # password reset form
    account = assigns(:account)

    # invalid email
    get edit_password_reset_path(account.reset_token, email: '')
    assert_redirected_to root_url

    # inactive account
    account.toggle!(:activated)
    get edit_password_reset_path(account.reset_token, email: account.email)
    assert_redirected_to root_url
    account.toggle!(:activated)

    # right email, wrong token
    get edit_password_reset_path('wrong token', email: account.email)
    assert_redirected_to root_url

    # right email right token
    get edit_password_reset_path(account.reset_token, email: account.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', account.email

    # invalid password and confirmation
    patch password_reset_path(account.reset_token), params: {
      email: account.email,
      account: {
        password: 'password',
        password_confirmation: 'egg'
      }
    }
    assert_select 'div.danger-box'

    # empty password
    patch password_reset_path(account.reset_token), params: {
      email: account.email,
      account: {
        password: '',
        password_confirmation: ''
      }
    }
    assert_select 'div.danger-box'

    # valid passowrd and confirmation
    patch password_reset_path(account.reset_token), params: {
      email: account.email,
      account: {
        password: 'password',
        password_confirmation: 'password'
      }
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to account
    follow_redirect!
    assert_select 'div.success-box'
  end
end
