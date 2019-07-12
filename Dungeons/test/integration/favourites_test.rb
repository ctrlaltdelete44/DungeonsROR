require 'test_helper'

class FavouritesTest < ActionDispatch::IntegrationTest
  def setup
    @account = accounts(:ferris)
    log_in_as @account
  end

  test "favourites page" do
    get favourites_account_path(@account)
    assert_not @account.favourites.empty?
    assert_match @account.favourites.count.to_s, response.body
    
    @account.favourites.each do |micropost|
      assert_select "h2", micropost.content
    end
  end
end
