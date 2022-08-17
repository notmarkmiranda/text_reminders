class RemindersController < ApplicationController
  before_action :require_user
  def index
    @reminders = current_user.reminders
  end

  def new
    @reminder = current_user.reminders.new
  end

  def create
    @reminder = current_user.reminders.new
    Time.use_zone("America/Denver") do
      @reminder.attributes = reminder_params
      time_in_zone = Time.zone.local(
        reminder_params["run_at(1i)"],
        reminder_params["run_at(2i)"],
        reminder_params["run_at(3i)"],
        reminder_params["run_at(4i)"],
        reminder_params["run_at(5i)"]
      )
      @reminder.run_at = time_in_zone
    end
    if @reminder.save
      flash[:alert] = "Your reminder has been created and scheduled!"
      TextSendingJob.perform_at(
        @reminder.run_at.in_time_zone("America/Denver"), @reminder.text
      )
      respond_to do |format|
        format.html { redirect_to reminders_path }
        format.turbo_stream
      end
    else
      flash[:alert] = @reminder.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:text, :run_at)
  end
end
