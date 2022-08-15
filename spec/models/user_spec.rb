require 'rails_helper'

RSpec.describe User, type: :model do
  before { create(:user) }

  it { should validate_presence_of :phone_number }
  it { should validate_uniqueness_of(:phone_number).case_insensitive }
end
