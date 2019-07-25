# # frozen_string_literal: true

# class PasswordResetsController < ApplicationController
#   before_action :get_account,    only: %i[edit update]
#   before_action :valid_account, only: %i[edit update]
#   before_action :check_expiration, only: %i[edit update]
#   def new; end

#   def create
#     @account = Account.find_by(email: params[:password_reset][:email].downcase)
#     if @account
#       @account.create_reset_digest
#       AccountMailer.password_reset(@account).deliver_now
#       flash[:info] = 'Password sent with reset instructions'
#       redirect_to root_url
#     else
#       flash.now[:danger] = 'Email address not found'
#       render 'new'
#     end
#   end

#   def edit; end

#   def update
#     if params[:account][:password].empty?
#       @account.errors.add(:password, "can't be empty'")
#       render 'edit'
#     elsif @account.update_attributes(account_params)
#       log_in @account
#       @account.update_attribute(:reset_digest, nil)
#       flash[:success] = 'Password reset successfully'
#       redirect_to @account
#     else
#       render 'edit'
#     end
#   end

#   private

#   def account_params
#     params.require(:account).permit(:password, :password_confirmation)
#   end

#   # before filters
#   def get_account
#     @account = Account.find_by(email: params[:email])
#   end

#   def valid_account
#     unless @account&.activated? && @account&.authenticated?(:reset, params[:id])
#       redirect_to root_url
#     end
#   end

#   def check_expiration
#     if @account.password_reset_expired?
#       flash[:danger] = 'Password reset has expired'
#       redirect_to new_password_reset_url
#     end
#   end
# end
