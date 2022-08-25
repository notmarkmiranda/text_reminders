require "rails_helper"

describe "Sessions Confirm", type: :request do
  let(:uuid) { create(:user).id }

  it "calls TextVerificationSenderJob" do
    expect(TextVerificationSenderJob).to receive(:perform_async).with(uuid)

    get "/confirm/#{uuid}"
  end
end
