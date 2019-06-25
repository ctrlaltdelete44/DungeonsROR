ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def is_logged_in?
    !session[:account_id].nil?
  end

  def log_in_as(account)
	session[:account_id] = account.id
  end

  class ActionDispatch::IntegrationTest
	def log_in_as(account, password: 'password', remember_me: '1')
		post login_path, params: { session: { email: account.email,
											  password: password, 
										      remember_me: remember_me }}
	end
  end
end
