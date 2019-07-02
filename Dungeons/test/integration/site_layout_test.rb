require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
	@account = accounts(:ferris)
  end

  test "layout links logged out" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
	assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path

	assert_select "a[href=?]", account_path(@account), count: 0
	assert_select "a[href=?]", edit_account_path(@account), count: 0
	assert_select "a[href=?]", accounts_path, count: 0
	assert_select "a[href=?]", logout_path, count: 0
  end

  test "layout links logged in" do
    get login_path
	log_in_as @account
	assert_redirected_to @account
	follow_redirect!

    assert_select "a[href=?]", root_path
	assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
	assert_select "a[href=?]", account_path(@account)
	assert_select "a[href=?]", edit_account_path(@account)
	assert_select "a[href=?]", accounts_path
	assert_select "a[href=?]", logout_path

    assert_select "a[href=?]", login_path, count: 0	
  end
end
