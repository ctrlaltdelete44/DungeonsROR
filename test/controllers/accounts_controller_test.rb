# frozen_string_literal: true

require 'test_helper'
class AccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @account = accounts(:ferris)
    @other_account = accounts(:axel)
  end

  test 'should redirect edit when not logged in' do
    get edit_account_path(@account)
    assert_not flash.empty?
    assert_redirected_to new_account_session_path
  end

  test 'should redirect update when not logged in' do
    patch account_path(@account), params: { account: { display_name: @account.display_name,
                                                       email: @account.email } }
    assert_not flash.empty?
    assert_redirected_to new_account_session_path
  end

  test 'should redirect index when not logged in' do
    get accounts_path
    assert_redirected_to new_account_session_path
  end

  test 'should not allow admin attribute to be updated via the web' do
    sign_in @other_account
    assert_not @other_account.admin?
    patch account_path(@other_account), params: { account: { password: @other_account.password,
                                                             password_confirmation: @other_account.password,
                                                             admin: true } }
    assert_not @other_account.reload.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Account.count' do
      delete account_path(@account)
    end
    assert_redirected_to new_account_session_path
  end

  test 'should redirect destroy when logged in as non-admin' do
    sign_in @other_account
    assert_no_difference 'Account.count' do
      delete account_path(@account)
    end
    assert_redirected_to root_url
  end

  test 'should redirect following when not logged in' do
    get following_account_path(@account)
    assert_redirected_to new_account_session_path
  end

  test 'should redirect followers when not logged in' do
    get followers_account_path(@account)
    assert_redirected_to new_account_session_path
  end

  test 'should redirect fvourites when not logged in' do
    get favourites_account_path(@account)
    assert_redirected_to new_account_session_path
  end
end
