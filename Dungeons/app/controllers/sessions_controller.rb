class SessionsController < ApplicationController
  def new
  end

  def create
    account = Account.find_by(email: params[:session][:email].downcase)
    if (account && account.authenticate(params[:session][:password]))
        log_in account
        redirect_to account
    else
        flash.now[:danger] = 'Invalid email/password combination' 
        render 'new'
    end
  end

  def destroy
  end
end
