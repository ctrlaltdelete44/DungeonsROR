# frozen_string_literal: true

require 'test_helper'
class MicropostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @micropost = microposts(:bacon)
  end
  test 'should redirect create when not logged in' do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: 'Lorem ipsum' } }
    end
    assert_redirected_to new_account_session_path
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to new_account_session_path
  end

  test 'should redirect destroy for wrong micropost' do
    sign_in accounts(:ferris)
    micropost = microposts(:bacon)

    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end

    assert_redirected_to root_url
  end
end
