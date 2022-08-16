require "rails_helper"

describe "Sessions verification request spec", type: :request do
  let(:user) { create(:user, verification: "1234") }

  subject(:post_verification) do
    post "/verification", params: { user_id: user.id, verification: verification_code }
  end

  describe "happy path" do
    let(:verification_code) { "1234" }

    it "has 302 status" do
      post_verification

      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq(nil)
    end
  end

  describe "sad path" do
    let(:verification_code) { "ASDF" }

    it "calls #clear_verification" do
      post_verification

      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq('Something went wrong')
    end
  end
end
