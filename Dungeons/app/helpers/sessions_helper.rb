module SessionsHelper

#logs in user
def log_in(account)
    session[:account_id] = account.id
end

#returns logged in user, or nil if none
def current_account
    if session[:account_id]
        @current_account ||= Account.find_by(id: session[:account_id])
    end
end

#returns boolean whether account is logged in
def logged_in?
    !current_user.nil?
end
end
