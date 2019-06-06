class SessionsController < ApplicationController
include SessionsHelper
def new
end

def create
	account = Account.find_by(username: params[:session][:username])
	if (account)
		login account
		redirect_to account
	else
		flash.now[:danger] = 'Invalid login'
		render 'new'
	end
end

def destroy
    log_out
    redirect_to root_url
end
end
