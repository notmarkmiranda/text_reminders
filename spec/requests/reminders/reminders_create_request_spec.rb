require "rails_helper"

describe "Reminders Create", type: :request do
  let(:reminder_attributes) { { reminder: attributes_for(:reminder) } }
  let(:user) { create(:user) }

  subject(:post_create) { post reminders_path, params: reminder_attributes }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow(TextSendingJob).to receive(:perform_at).with(any_args).and_return(nil)

    run_at = reminder_attributes[:reminder][:run_at]
    reminder_attributes[:reminder]["run_at(1i)"] = run_at.year.to_s
    reminder_attributes[:reminder]["run_at(2i)"] = run_at.month.to_s
    reminder_attributes[:reminder]["run_at(3i)"] = run_at.day.to_s
    reminder_attributes[:reminder]["run_at(4i)"] = run_at.hour.to_s
    reminder_attributes[:reminder]["run_at(5i)"] = run_at.min.to_s
    reminder_attributes[:reminder].delete(:run_at)
  end

  it "saves in mountain time" do
    expect { post_create }.to change(Reminder, :count).by(1)
    expect(TextSendingJob).to have_received(:perform_at).with(
      time_in_zone(reminder_attributes), Integer
    ).once
  end

  def time_in_zone(attributes)
    Time.use_zone("America/Denver") do
      Time.zone.local(
        attributes[:reminder]["run_at(1i)"],
        attributes[:reminder]["run_at(2i)"],
        attributes[:reminder]["run_at(3i)"],
        attributes[:reminder]["run_at(4i)"],
        attributes[:reminder]["run_at(5i)"]
      )
    end
  end
end
