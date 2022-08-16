class User < ApplicationRecord
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }

  def generate_verification_code
    update(verification: random_verification_code, verification_expiration: 15.minutes.from_now)
  end

  def verify(code)
    authorized = verification == code && verification_expiration > Time.now
    clear_verification
    authorized
  end

  def clear_verification
  end

  private

  def random_verification_code
    string = ""
    4.times { string += rand(0..9).to_s }
    string
  end
end
