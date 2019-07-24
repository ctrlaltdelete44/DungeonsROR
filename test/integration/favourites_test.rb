# frozen_string_literal: true

require 'test_helper'

class FavouritesTest < ActionDispatch::IntegrationTest
  def setup
    @account = accounts(:ferris)
    @micropost = microposts(:hello)
    log_in_as @account
  end

  test 'favourites page' do
    get favourites_account_path(@account)
    assert_not @account.favourites.empty?
    assert_match @account.favourites.count.to_s, response.body

    @account.favourites.each do |micropost|
      assert_select 'p', micropost.content
    end
  end

  test 'should favourite a post' do
    assert_difference '@account.favourites.count', 1 do
      post favourites_path, params: { micropost_id: @micropost.id }
    end
  end

  test 'should unfavourite a post' do
    @account.favourite(@micropost)
    favourite = @account.favourite_posts.find_by(micropost_id: @micropost.id)
    assert_difference '@account.favourites.count', -1 do
      delete favourite_path(favourite)
    end
  end
end
