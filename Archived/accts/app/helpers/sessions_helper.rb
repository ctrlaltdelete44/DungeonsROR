module SessionsHelper

def login(account)
	session[:account_id] = account.id
end

def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
end

def is_logged_in
    !current-user.nil?
end

def logout
    session.delete(:user_id)
    @current_user = nil
end
end
