# frozen_string_literal: true

require 'test_helper'

class AccountsLoginTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @account = accounts(:ferris)
  end

  # test for flashes lasting for a page too long after error in login
  test 'login with invalid information' do
    get new_account_session_path
    assert_template 'sessions/new'
    post account_session_path, params: { account: { email: '', password: '' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # test for links appearing correctly on login
  test 'login with valid information followed by logout' do
    get new_account_session_path
    assert_template 'sessions/new'
    post account_session_path, params: { account: { email: @account.email,
                                          password: 'password' } } 
    assert_redirected_to root_url
    
    follow_redirect!
    assert_select 'p', "Signed in successfully."
    assert_select 'h2', @account.display_name
    assert_select 'a[href=?]', new_account_session_path, count: 0
    assert_select 'a[href=?]', destroy_account_session_path
    assert_select 'a[href=?]', account_path(@account)

    delete destroy_account_session_path
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'a[href=?]', new_account_session_path

    # simulate user logging out in seperate window
    delete destroy_account_session_path
    follow_redirect!
    assert_select 'a[href=?]', new_account_session_path
    assert_select 'a[href=?]', destroy_account_session_path, count: 0
    assert_select 'a[href=?]', account_path(@account), count: 0
  end
end
