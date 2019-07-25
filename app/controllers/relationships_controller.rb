# frozen_string_literal: true

class RelationshipsController < ApplicationController
  # before_action :logged_in_user

  def create
    account = Account.find(params[:followed_id])
    current_account.follow(account)
    redirect_to account
  end

  def destroy
    account = Relationship.find(params[:id]).followed
    current_account.unfollow(account)
    redirect_to account
  end
end
