require "rails_helper"

describe "Visitor is redirected on bad verification code", type: :system do
  it "redirects when the incorrect verification code is inputted" do
    visit sign_in_path

    fill_in "Phone Number", with: "3038675309"
    click_button "Next"

    fill_in "Verification Code", with: "XYZA"
    click_button "Verify"

    expect(current_path).to eq(sign_in_path)
  end
end
