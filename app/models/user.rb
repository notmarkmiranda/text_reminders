class User < ApplicationRecord
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }
end
