# frozen_string_literal: true

require 'test_helper'

class FavouriteTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  def setup
    @relationship = Favourite.new(account_id: accounts(:ferris).id,
                                  micropost_id: microposts(:bacon).id)
  end

  test 'should be valid' do
    assert @relationship.valid?
  end

  test 'should require an account' do
    @relationship.account_id = nil
    assert_not @relationship.valid?
  end

  test 'should require a post' do
    @relationship.micropost_id = nil
    assert_not @relationship.valid?
  end
end
