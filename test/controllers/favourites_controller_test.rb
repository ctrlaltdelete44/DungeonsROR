# frozen_string_literal: true

require 'test_helper'

class FavouritesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test 'create should require a logged-in account' do
    assert_no_difference 'Favourite.count' do
      post favourites_path
    end
    assert_redirected_to new_account_session_path
  end

  test 'destroy should require a logged-in account' do
    assert_no_difference 'Favourite.count' do
      delete favourite_path(favourites(:one))
    end
    assert_redirected_to new_account_session_path
  end
end
