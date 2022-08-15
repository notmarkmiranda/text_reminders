class RemindersController < ApplicationController
  def index
    @reminders = Reminder.all
  end

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = Reminder.new
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
      redirect_to reminders_path
    else
      flash[:alert] = @reminder.errors.full_messages.join(", ")
      render :new
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:text, :run_at)
  end
end
