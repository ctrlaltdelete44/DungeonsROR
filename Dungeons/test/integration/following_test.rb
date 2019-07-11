require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @account = accounts(:ferris)
    @other_account = accounts(:axel)
    log_in_as(@account)
  end

  test "following page" do
    get following_account_path(@account)
    assert_not @account.following.empty?
    assert_match @account.following.count.to_s, response.body
    @account.following.each do |account|
      assert_select "a[href=?]", account_path(account)
    end
  end

  test "followers page" do
    get followers_account_path(@account)
    assert_not @account.followers.empty?
    assert_match @account.followers.count.to_s, response.body
    @account.followers.each do |account|
      assert_select "a[href=?]", account_path(account)
    end
  end

  test "should follow account standard way" do
    @account.unfollow @other_account;
    assert_difference '@account.following.count', 1 do
      post relationships_path, params: { followed_id: @other_account.id }
    end
  end

  test "should unfollow account standard way" do
    relationship = @account.active_relationships.find_by(followed_id: @other_account.id)
    assert_difference '@account.following.count', -1 do
      delete relationship_path(relationship)
    end
  end
end
