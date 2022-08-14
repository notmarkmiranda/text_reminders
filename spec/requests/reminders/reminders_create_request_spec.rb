require "rails_helper"

describe "Reminders Create", type: :request do
  let(:reminder_attributes) { { reminder: attributes_for(:reminder) } }
  subject(:post_create) { post reminders_path, params: reminder_attributes }

  before { allow(TextSendingJob).to receive(:perform_at).with(any_args).and_return(nil) }

  it "saves in mountain time" do
    post_create
  end
end
