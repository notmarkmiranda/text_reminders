class Reminder < ApplicationRecord
  validates :text, presence: true

  belongs_to :user

  delegate :phone_number, to: :user, prefix: true
  delegate :timezone, to: :user, prefix: true
end
