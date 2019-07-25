# # frozen_string_literal: true

 module SessionsHelper
#   # logs in user
#   def log_in(account)
#     session[:account_id] = account.id
#   end

#   # remembers a user
#   def remember(account)
#     account.remember
#     cookies.permanent.signed[:account_id] = account.id
#     cookies.permanent[:remember_token] = account.remember_token
#   end

#   # logs out user
#   def log_out
#     forget(current_account)
#     session.delete(:account_id)
#     @current_account = nil
#   end

#   # forgets a user
#   def forget(account)
#     account.forget
#     cookies.delete(:account_id)
#     cookies.delete(:remember_token)
#   end

#   # returns logged in user, or nil if none
#   def current_account
#     if (account_id = session[:account_id])
#       @current_account ||= Account.find_by(id: account_id)
#     elsif (account_id = cookies.signed[:account_id])
#       account = Account.find_by(id: account_id)
#       if account&.authenticated?(:remember, cookies[:remember_token])
#         log_in account
#         @current_account = account
#       end
#     end
#   end

#   # returns boolean if whether current account matches given account
#   def current_account?(account)
#     account == current_account
#   end

#   # returns boolean whether account is logged in
#   def logged_in?
#     !current_account.nil?
#   end

#   def redirect_back_or(default)
#     redirect_to(session[:forwarding_url] || default)
#     session.delete(:forwarding_url)
#   end

#   def store_location
#     session[:forwarding_url] = request.original_url if request.get?
#   end
 end
