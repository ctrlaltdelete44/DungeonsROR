# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  def edit
    account = Account.find_by(email: params[:email])
    if account && !account.activated? && account.authenticated?(:activation, params[:id])
      account.activate
      log_in account
      flash[:success] = 'Account activated successfully'
      redirect_to account
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end
end
