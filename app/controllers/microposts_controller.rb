# frozen_string_literal: true

class MicropostsController < ApplicationController
  # before_action :logged_in_user, only: %i[create destroy]
  # before_action :correct_account, only: :destroy

  def create
    @micropost = current_account.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture_new)
    end

  def correct_account
    @micropost = current_account.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
    end
end
