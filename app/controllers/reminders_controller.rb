class RemindersController < ApplicationController
  def index
    @reminders = Reminder.all
  end

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = Reminder.new(reminder_params)
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
