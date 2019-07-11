require 'test_helper'

class AccountProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
	@account = accounts(:ferris)
  end

  test "profile display" do
	get account_path(@account)
	assert_template 'accounts/show'
	assert_select 'title', full_title(@account.display_name)
	assert_select 'h2', @account.display_name
	
	assert_select 'a.stat', count: 3
	assert_match @account.following.count.to_s, response.body
	assert_match @account.followers.count.to_s, response.body

	assert_match @account.microposts.count.to_s, response.body
	assert_select 'div.pagination'
	@account.microposts.paginate(page: 1).each do |micropost|
		assert_match micropost.content, response.body
	end
  end
end
