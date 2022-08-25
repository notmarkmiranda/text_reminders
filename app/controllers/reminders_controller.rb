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
    @reminder.attributes = reminder_params
    @reminder.run_at = time_in_zone(reminder_params)
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

  def time_in_zone(attributes)
    Time.use_zone("America/Denver") do
      Time.zone.local(
        attributes["run_at(1i)"],
        attributes["run_at(2i)"],
        attributes["run_at(3i)"],
        attributes["run_at(4i)"],
        attributes["run_at(5i)"]
      )
    end
  end
end
