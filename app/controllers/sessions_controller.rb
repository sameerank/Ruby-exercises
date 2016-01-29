class SessionsController < ApplicationController
  before_action :require_user_to_be_signed_in!, only: [:destroy]
  before_action :require_user_to_not_be_signed_in!, only: [:create, :new]

  def create
    @user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )
    if @user.nil?
      flash.now[:errors] = ["Email and/or password are incorrect"]
      render :new
    else
      log_in_user!(@user)
      redirect_to user_url(@user[:id])
    end
  end

  def new
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end

end
