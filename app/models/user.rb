class User < ApplicationRecord
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }

  has_many :reminders

  def generate_verification_code
    update(verification: random_verification_code, verification_expiration: 15.minutes.from_now)
  end

  def verify(code)
    authorized = verification == code.to_s && verification_expiration > Time.now
    clear_verification
    authorized
  end

  private

  def clear_verification
    update(verification: nil, verification_expiration: nil)
  end

  def random_verification_code
    string = ""
    4.times { string += rand(0..9).to_s }
    string
  end
end
