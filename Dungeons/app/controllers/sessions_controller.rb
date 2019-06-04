class SessionsController < ApplicationController
def new
end

def create
	account = Account.find_by(username: params[:session][:username])
	if (account)
		login_url account
		redirect_to account
	else
		flash.now[:danger] = 'Invalid login'
		render 'new'
	end
end

def destroy
end
end
