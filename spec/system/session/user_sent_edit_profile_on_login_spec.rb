require "rails_helper"

RSpec.describe "User is redirected to edit profile on sign in", type: :system do
  let(:user) { create(:user, timezone: nil) }

  it "redirects to edit_profile when user does not have strike zone" do
    user.generate_verification_code

    visit confirm_path(user.id)
    fill_in "Verification Code", with: user.verification
    click_button "Verify"

    expect(current_path).to eq(edit_profile_path)
  end
end
