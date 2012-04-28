class SessionsController < ApplicationController
  layout 'login'
  
  def new
  end

  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password]) # user exist and can be authenticate
      session[:user_id] = user.id
      if user.roles.where(:name => 'admin')
        redirect_to admin_root_url, :notice => "Logged In!"
      else
      end
    else
      flash.now.alert = "Invalid username or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
