require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  def setup
	@account = accounts(:ferris)
	@other_account = accounts(:axel)
  end

  test "should redirect edit when not logged in" do
	get edit_account_path(@account)
	assert_not flash.empty?
	assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
	patch account_path(@account), params: { account: { display_name: @account.display_name,
													   email: @account.email } }
	assert_not flash.empty?
	assert_redirected_to login_url
  end

  test "should redirect index when not logged in" do
	get accounts_path
	assert_redirected_to login_url
  end
end
