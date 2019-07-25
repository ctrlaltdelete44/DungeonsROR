# frozen_string_literal: true

require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test 'create should require logged-in account' do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to new_account_session_path
  end

  test 'destroy should require logged_in account' do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to new_account_session_path
  end
end
