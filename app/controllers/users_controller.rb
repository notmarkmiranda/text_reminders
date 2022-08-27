class UsersController < ApplicationController
  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to reminders_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:timezone, :phone_number)
  end
end
