class AccountsController < ApplicationController
def show
	@account = Account.find(params[:id])
end
def new
	@account = Account.new
end

def create
	@account = Account.new(account_params)

	if @account.save
		redirect_to @account
	else
		render 'new'
	end
end

private
	def account_params
		params.require(:account).permit(:username, :email, :display_name)
	end
end
