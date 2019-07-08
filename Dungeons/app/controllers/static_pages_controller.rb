class StaticPagesController < ApplicationController
  def home
	@micropost = current_account.microposts.build if logged_in?
  end

  def help
  end

  def about
  end
end
