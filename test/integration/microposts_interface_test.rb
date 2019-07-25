# frozen_string_literal: true

require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @account = accounts(:ferris)
  end

  test 'micropost interface' do
    # setup
    sign_in @account
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    # invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: '' } }
    end
    assert_template 'static_pages/home'
    assert_select 'div.danger-box'

    # valid submission
    content = 'Micropost content'
    picture = fixture_file_upload('test/fixtures/cat.jpeg', 'image/jpeg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content,
                                                   picture: picture } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

    # delete post
    assert_select 'a', text: 'Delete'
    first_micropost = @account.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # confirm no delete links on other accounts
    get account_path(accounts(:axel))
    assert_select 'a', text: 'Delete', count: 0
  end

  test 'micropost sidebar count' do
    sign_in @account
    get root_path
    assert_match "#{@account.microposts.count} Microposts", response.body

    # account with 0 microposts
    other_account = accounts(:malcolm)
    sign_in other_account
    get root_path

    assert_match '0 Microposts', response.body
    other_account.microposts.create!(content: 'Micropost :)')
    get root_path
    assert_match '1 Micropost', response.body
  end
end
