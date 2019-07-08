class AccountsController < ApplicationController
before_action :logged_in_user,	only: [:index, :edit, :update, :destroy]
before_action :correct_user,	only: [:edit, :update]
before_action :admin_user,		only: [:destroy]

def index
	@accounts = Account.where(activated: true).paginate(page: params[:page])
end

def show
    @account = Account.find(params[:id])
	@microposts = @account.microposts.paginate(page: params[:page])
	redirect_to root_url and return unless @account.activated == true
end

def new
    @account = Account.new
end

def create
    @account = Account.new(account_params)
    if @account.save
		@account.send_activation_email
		flash[:info] = "Please check your email and activate you account."
		redirect_to root_url
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

def destroy
	Account.find(params[:id]).destroy
	flash[:success] = "Account deleted"
	redirect_to accounts_url
end

private
    def account_params
        params.require(:account).permit(:display_name, :email,
                                        :password, :password_confirmation)
    end

	def correct_user
		@account = Account.find(params[:id])
		redirect_to(root_url) unless current_account?(@account)
	end

	def admin_user
		redirect_to(root_url) unless current_account.admin?
	end
end
