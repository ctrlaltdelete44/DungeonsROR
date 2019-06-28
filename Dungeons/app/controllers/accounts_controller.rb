class AccountsController < ApplicationController
before_action :logged_in_user,	only: [:edit, :update]
before_action :correct_user,	only: [:edit, :update]
def show
    @account = Account.find(params[:id])
end

def new
    @account = Account.new
end

def create
    @account = Account.new(account_params)
    if @account.save
        log_in @account
        flash[:success] = "Account created!"
        redirect_to @account
    else
        render 'new'
    end
end

def edit
	@account = Account.find(params[:id])
end

def update
	@account = Account.find(params[:id])
	if (@account.update_attributes(account_params))
		flash[:success] = "Profile updated"
		redirect_to @account
	else
		render 'edit'
	end
end

private
    def account_params
        params.require(:account).permit(:display_name, :email, 
                                                                           :password, :password_confirmation)
    end

	def logged_in_user
		unless logged_in?
			flash[:danger] = "Please log in to access that page"
			redirect_to login_url
		end
	end

	def correct_user
		@account = Account.find(params[:id])
		redirect_to(root_url) unless current_account?(@account)
	end
end
