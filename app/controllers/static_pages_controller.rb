# frozen_string_literal: true

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_account!
  def home
    if account_signed_in?
      @micropost = current_account.microposts.build
      @feed_items = current_account.feed.paginate(page: params[:page])
    end
  end

  def help; end

  def about; end
end
