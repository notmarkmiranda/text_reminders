class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_or_create_by(phone_number: user_params[:phone_number])
    user.generate_verification_code
    redirect_to confirm_path(user.id)
  end

  def verification
    user = User.find(params[:user_id])
    if user&.verify(params[:verification])
      redirect_to reminders_path
    else
      flash[:alert] = "Something went wrong"
      redirect_to sign_in_path
    end
  end

  private

  def user_params
    params.permit(:phone_number)
  end
end
