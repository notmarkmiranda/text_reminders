class RemindersController < ApplicationController
  def index
    @reminders = Reminder.all
  end

  def new
  end

  def create
  end
end
