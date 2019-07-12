# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_account.microposts.build
      @feed_items = current_account.feed.paginate(page: params[:page])
    end
  end

  def help; end

  def about; end
end
