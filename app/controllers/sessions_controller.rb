class SessionsController < ApplicationController

  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      login_user!(user)
    else
      flash[:error] = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have been signed out'
    redirect_to root_path
  end

  def login_user!(user)
    session[:user_id] = user.id
    flash[:notice] = 'Login successful'
    redirect_to home_path
  end


end