require 'test_helper'

class AccountsEditTest < ActionDispatch::IntegrationTest
  def setup
	@account = accounts(:ferris)
  end

  test "unsuccessful edit" do
	log_in_as(@account)

	get edit_account_path(@account)
	assert_template 'accounts/edit'
	patch account_path(@account), params: { account: { display_name: "",
													   email: "foo@invalid",
													   password: "pass",
													   password_confirmation: "word" } }
	assert_template 'accounts/edit'
	assert_select "h2.danger-msg", "The form could not be saved due to the following 3 errors"
  end

  test "successful edit" do
	log_in_as(@account)

	get edit_account_path(@account)
	assert_template 'accounts/edit'
	display_name = "Captain Ya Boi"
	email = "email@gmail.com"
	patch account_path(@account), params: { account: { display_name: display_name,
													   email: email,
													   password: "",
													   password_confirmation: "" } }
	#test ui behaves correctly
	assert_not flash.empty?
	assert_redirected_to @account

	#test data behaves correctly
	@account.reload
	assert_equal display_name, @account.display_name
	assert_equal email, @account.email
  end
end
