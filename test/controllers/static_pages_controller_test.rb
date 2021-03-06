# frozen_string_literal: true

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  def setup
    @base_title = 'Dungeons'
  end

  test 'should get home' do
    get root_path
    assert_response :success
    assert_select 'title', "Dashboard | #{@base_title}"
  end

  test 'should get help' do
    get help_path
    assert_response :success
    assert_select 'title', "Help | #{@base_title}"
  end

  test 'should get about' do
    get about_path
    assert_response :success
    assert_select 'title', "About | #{@base_title}"
  end
end
