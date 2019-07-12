# frozen_string_literal: true

require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:bacon)
  end
  test 'should redirect create when not logged in' do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: 'Lorem ipsum' } }
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy for wrong micropost' do
    log_in_as accounts(:ferris)
    micropost = microposts(:bacon)

    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end

    assert_redirected_to root_url
  end
end
