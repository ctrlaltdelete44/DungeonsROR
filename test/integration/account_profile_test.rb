# frozen_string_literal: true

require 'test_helper'

class AccountProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include Devise::Test::IntegrationHelpers
  
  def setup
    @account = accounts(:ferris)
    sign_in @account
  end

  test 'profile display' do
    get account_path(@account)
    assert_template 'accounts/show'
    assert_select 'title', full_title(@account.display_name)
    assert_select 'h2.f3', @account.display_name

    assert_select 'a[href=?]', send_test_email_path, text: "Send test email"
    get send_test_email_path
    assert_not flash.empty?
    follow_redirect!

    assert_match @account.following.count.to_s, response.body
    assert_match @account.followers.count.to_s, response.body

    assert_match @account.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @account.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
