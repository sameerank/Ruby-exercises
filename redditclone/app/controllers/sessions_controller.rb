class SessionsController < ApplicationController

  before_action :require_logged_in, only: [:destroy]
  before_action :require_logged_out, only: [:new, :create]

  def new
    @user = User.new()
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params)
    if @user
      login_user!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ["Username and password do not match."]
      @user = User.new(user_params)
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end
end
