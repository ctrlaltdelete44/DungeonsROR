require 'test_helper'

class AccountsIndexTestTest < ActionDispatch::IntegrationTest
  def setup
	@admin = accounts(:ferris)
	@non_admin = accounts(:axel)
  end

  test "index as admin using pagination and delete links" do
	log_in_as @admin
	get accounts_path
	assert_template 'accounts/index'
	assert_select 'div.pagination'
	Account.paginate(page: 1).each do |account|
		assert_select 'a[href=?]', account_path(account), text: account.display_name
		unless account == @admin
			assert_select 'a[href=?]', account_path(account), text: 'Delete'
		end
	end

	assert_difference 'Account.count', -1 do
		delete account_path(@non_admin)
	end
  end

  test "index as non-admin" do
	log_in_as @non_admin
	get accounts_path
	assert_select 'a', text: 'delete', count: 0
  end
end
