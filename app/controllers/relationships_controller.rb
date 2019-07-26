# frozen_string_literal: true

class RelationshipsController < ApplicationController

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
