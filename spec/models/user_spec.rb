require 'rails_helper'

RSpec.describe User, type: :model do
  before { create(:user) }

  it { should validate_presence_of :phone_number }
  it { should validate_uniqueness_of(:phone_number).case_insensitive }
  it { should have_many :reminders }

  describe "format validation" do
    let(:user) { build(:user) }

    it "errors when the number is > 10" do
      user.phone_number = "12345678901"

      expect(user.save).to eq(false)
      expect(user.errors.full_messages).to include("Phone number must be 10 digits")
    end

    it "errors when the number is < 10" do
      user.phone_number = "123456789"

      expect(user.save).to eq(false)
      expect(user.errors.full_messages).to include("Phone number must be 10 digits")
    end

    it "errors when the number contains letters" do
      user.phone_number = "1234a67890"

      expect(user.save).to eq(false)
      expect(user.errors.full_messages).to include("Phone number must be digits only")
    end
  end

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
