class SessionsController < ApplicationController
  before_action :reject_user, only: [:new, :create, :confirm]

  def create
    user = User.find_or_create_by(phone_number: user_params[:phone_number])
    user.generate_verification_code
    redirect_to confirm_path(user.id)
  end

  def confirm
    TextVerificationSenderJob.perform_async(params[:uuid])
  end

  def verification
    user = User.find(params[:user_id])
    if user&.verify(params[:verification])
      session[:user_id] = user.id
      login_redirect
    else
      flash[:alert] = "Something went wrong"
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to sign_in_path
  end

  private

  def login_redirect
    if current_user.timezone.present?
      redirect_to reminders_path
    else
      redirect_to edit_profile_path
    end
  end

  def user_params
    params.permit(:phone_number)
  end
end
