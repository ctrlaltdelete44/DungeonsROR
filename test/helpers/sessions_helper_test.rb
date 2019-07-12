# frozen_string_literal: true

require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @account = accounts(:ferris)
    remember(@account)
  end

  test 'current_user returns right acct when session is nil' do
    assert_equal @account, current_account
    assert is_logged_in?
  end

  test 'current_user returns nil when remember digest is wrong' do
    @account.update_attribute(:remember_digest, Account.digest(Account.new_token))
    assert_nil current_account
  end
end
