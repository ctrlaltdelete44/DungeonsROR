# frozen_string_literal: true

require 'test_helper'
class SiteLayoutTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @account = accounts(:ferris)
  end

  test 'layout links logged out' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', new_account_session_path

    assert_select 'a[href=?]', account_path(@account), count: 0
    assert_select 'a[href=?]', edit_account_registration_path(@account), count: 0
    assert_select 'a[href=?]', accounts_path, count: 0
    assert_select 'a[href=?]', destroy_account_session_path, count: 0
  end

  test 'layout links logged in' do
    get new_account_session_path
    sign_in @account
    post account_session_path
    assert_redirected_to root_url
    follow_redirect!

    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', account_path(@account)
    assert_select 'a[href=?]', edit_account_registration_path(@account)
    assert_select 'a[href=?]', accounts_path
    assert_select 'a[href=?]', destroy_account_session_path

    assert_select 'a[href=?]', new_account_session_path, count: 0
  end
end
