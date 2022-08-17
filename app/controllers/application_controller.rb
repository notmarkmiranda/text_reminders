class ApplicationController < ActionController::Base
  helper_method :current_user

  def require_user
    redirect_to sign_in_path unless current_user
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
