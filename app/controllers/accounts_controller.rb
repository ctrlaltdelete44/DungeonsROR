# frozen_string_literal: true

class AccountsController < ApplicationController
  skip_before_action :authenticate_account!, only: [:new, :create]

  before_action :correct_user,  except: [:index, :show, :new, :create, :destroy, :favourites, :send_test_email]
  before_action :admin_user,    except: [:index, :show, :new, :create, :edit, :update, :following, :followers, :favourites]

  def index
    @accounts = Account.paginate(page: params[:page])
  end

  def show
    @account = Account.find(params[:id])
    @microposts = @account.microposts.paginate(page: params[:page])
    redirect_to(root_url) && return unless current_account.confirmed?
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      flash[:info] = 'Please check your email and activate you account.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    update_params
    if @account.update_attributes(account_params)
      flash[:success] = 'Profile updated'
      unless @account.email == params[:account][:email]
        flash[:info] = 'You will need to confirm this email address before it can update'
        redirect_to root_url
      else
        bypass_sign_in(@account)
        redirect_to @account
      end
    else
      render 'edit'
    end
  end

  def destroy
    Account.find(params[:id]).destroy
    flash[:success] = 'Account deleted'
    redirect_to accounts_url
  end

  def following
    @title = 'Following'
    @account = Account.find(params[:id])
    @accounts = @account.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @account = Account.find(params[:id])
    @accounts = @account.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def favourites
    @title = 'Favourites'
    @account = Account.find(params[:id])
    @posts = @account.favourites.paginate(page: params[:page])
    render 'show_favourites'
  end

  def send_test_email
    @account = current_account
    SendTestEmailsJob.perform_later @account
    flash[:info] = "Test email has been sent"
    redirect_to @account
  end

  def test_migration
    MigrateJob.perform_later
    redirect_to current_account
  end

  private

  def account_params
    params.require(:account).permit(:display_name, :email,
                                    :password, :password_confirmation)
  end

  def update_params
    if params[:account][:password].blank? && params[:account][:password_confirmation].blank?
      params[:account].delete(:password)
      params[:account].delete(:password_confirmation)
    end
  end

  def correct_user
  @account = Account.find(params[:id])
    unless current_account == @account
      flash[:warning] = "You do not have access to this page"
      redirect_to root_url
    end
  end

  def admin_user
    redirect_to(root_url) unless current_account.admin?
  end
end
