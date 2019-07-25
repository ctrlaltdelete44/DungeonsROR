# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def logged_in_user
    unless account_signed_in?
      flash[:danger] = 'Please log in to access that page'
      redirect_to new_account_session_path
    end
  end
end
