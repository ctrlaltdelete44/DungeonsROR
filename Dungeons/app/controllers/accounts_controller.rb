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
        flash[:success] = "Account created!"
        redirect_to @account
    else
        render 'new'
    end
end

private
    def account_params
        params.require(:account).permit(:display_name, :email, 
                                                                           :password, :password_confirmation)
    end

end
