# frozen_string_literal: true

require 'test_helper'

class AccountsEditTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @account = accounts(:ferris)
    sign_in @account
  end

  test 'unsuccessful edit' do
    get edit_account_path(@account)
    assert_template 'accounts/edit'
    patch account_path(@account), params: { account: { display_name: '',
                                                       email: 'foo@invalid',
                                                       password: 'pass',
                                                       password_confirmation: 'word' } }
    assert_template 'accounts/edit'
    assert_select 'h2.danger-msg', 'The form could not be saved due to the following 3 errors'
  end

  test 'successful edit without changing email password' do
    get edit_account_path(@account)

    display_name = 'Captain Ya Boi'
    email = @account.email

    patch account_path(@account), params: { account: { display_name: display_name,
                                                       email: email,
                                                       password: '',
                                                       password_confirmation: '' } }

    follow_redirect!

    # test ui behaves correctly
    assert_not flash.empty?
    assert_select 'p.success-msg', 'Profile updated'
    assert_select 'h1', display_name

    # test data behaves correctly
    @account.reload
    assert_equal display_name, @account.display_name
    assert_equal email, @account.email
  end

  test 'successful edit with password changing' do
    get edit_account_path @account

    email = @account.email
    display_name = @account.display_name
    password = 'password'

    patch account_path(@account), params: { account: { display_name: display_name,
                                                       email: email,
                                                       password: password,
                                                       password_confirmation: password } }
    follow_redirect!
    # test ui behaves correctly
    assert_not flash.empty?
    assert_select 'p.success-msg', 'Profile updated'
    assert_select 'h1', display_name

    # test data behaves correctly
    @account.reload
    assert_equal display_name, @account.display_name
    assert_equal email, @account.email
  end

  test 'successful edit with email changing' do
    get edit_account_path @account

    email = 'a@example.com'
    display_name = @account.display_name
    patch account_path(@account), params: { account: { display_name: display_name,
                                                       email: email,
                                                       password: '',
                                                       password_confirmation: '' } }

    follow_redirect!
    assert_select 'p.success-msg', 'Profile updated'
    assert_select 'p.info-msg', 'You will need to confirm this email address before it can update'
    assert_select 'h1', 'Dashboard'

    @account.reload
    assert_equal email, @account.unconfirmed_email
    assert_equal display_name, @account.display_name
  end
end
