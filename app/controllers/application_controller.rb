class ApplicationController < ActionController::Base
  helper_method :current_user, :edit_profile_page?

  def require_user
    redirect_to sign_in_path unless current_user
  end

  def reject_user
    redirect_to reminders_path if current_user
  end

  def edit_profile_page?
    params[:controller] == "users" && params[:action] == "edit"
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
