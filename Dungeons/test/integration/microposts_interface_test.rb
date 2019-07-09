require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
	@account = accounts(:ferris)
  end

  test "micropost interface" do
	#setup
	log_in_as @account
	get root_path
	assert_select 'div.pagination'

	#invalid submission
	assert_no_difference 'Micropost.count' do
		post microposts_path, params: { micropost: { content: "" } }
	end
	assert_select 'div.danger-box'

	#valid submission
	content = "Micropost content"
	assert_difference 'Micropost.count', 1 do
		post microposts_path, params: { micropost: { content: content } }
	end
	assert_redirected_to root_url
	follow_redirect!
	assert_match content, response.body

	#delete post
	assert_select 'a', text: 'Delete'
	first_micropost = @account.microposts.paginate(page: 1).first
	assert_difference 'Micropost.count', -1 do
		delete micropost_path(first_micropost)
	end

	#confirm no delete links on other accounts
	get account_path(accounts(:axel))
	assert_select 'a', text: 'Delete', count: 0
  end

  test "micropost sidebar count" do
	log_in_as @account
	get root_path
	assert_match "#{@account.microposts.count} Microposts", response.body

	#account with 0 microposts
	other_account = accounts(:malcolm)
	log_in_as other_account
	get root_path

	assert_match "0 Microposts", response.body
	other_account.microposts.create!(content: "Micropost :)")
	get root_path
	assert_match "1 Micropost", response.body
  end
end
