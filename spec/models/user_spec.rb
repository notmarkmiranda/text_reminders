require 'rails_helper'

RSpec.describe User, type: :model do
  before { create(:user) }

  it { should validate_presence_of :phone_number }
  it { should validate_uniqueness_of(:phone_number).case_insensitive }

  describe "#verify" do
    let(:user) { create(:user, verification: "0987") }

    it "returns true" do
      expect(user.verify("0987")).to eq(true)
    end

    it "returns false" do
      expect(user.verify("1234")).to eq(false)
    end

    after do
      expect(user.verification).to be nil
      expect(user.verification_expiration).to be nil
    end
  end
end
