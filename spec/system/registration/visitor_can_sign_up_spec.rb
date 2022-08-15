require "rails_helper"

RSpec.describe "Visitor can sign up", type: :system do
  before do
    allow_any_instance_of(User).to receive(:verify).with("1234").and_return true
  end

  it "redirects to /reminders" do
    visit "/sign-in"

    fill_in "Phone Number", with: "3038476953"
    click_button "Next"

    expect(page).to have_content("Confirm Phone Number")
    fill_in "Verification Code", with: "1234"
    click_button "Verify"

    expect(current_path).to eq(reminders_path)
  end
end
