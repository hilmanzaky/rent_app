class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def admin_required
    role = current_user.roles.where(:name => "admin") unless session[:user_id].blank?
    if role.blank?
      redirect_to root_path
    end
  end
  
  helper_method :current_user
end
