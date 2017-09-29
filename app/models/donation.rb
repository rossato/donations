class Donation < ActiveRecord::Base
  belongs_to :donor
  validates :donor, presence: true

  belongs_to :user

  validates :amount, numericality: {greater_than: 0}
  validate :is_valid_amount?

  def is_valid_amount?
    if amount != amount.round(2)
      errors.add(:amount, "must not have fractional cents")
    end
  end
end
