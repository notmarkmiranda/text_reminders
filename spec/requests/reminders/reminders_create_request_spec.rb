require "rails_helper"

describe "Reminders Create", type: :request do
  let(:reminder_attributes) { { reminder: attributes_for(:reminder) } }
  subject(:post_create) { post reminders_path, params: reminder_attributes }

  before do
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
  end
end
