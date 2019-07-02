require 'test_helper'

class AccountsIndexTestTest < ActionDispatch::IntegrationTest
  def setup
	@account = accounts(:ferris)
  end

  test "index using pagination" do
	log_in_as @account
	get accounts_path
	assert_template 'accounts/index'
	assert_select 'div.pagination'
	Account.paginate(page: 1).each do |account|
		assert_select 'a[href=?]', account_path(account), text: account.display_name
	end
  end
end
