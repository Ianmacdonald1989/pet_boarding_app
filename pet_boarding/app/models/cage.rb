class Cage < ApplicationRecord
  enum size: { small: 'small', medium: 'medium', large: 'large' }

  # `bookings.cage_size` stores which cage size the booking needs, so we can
  # navigate from a cage inventory row to its bookings.
  has_many :bookings, foreign_key: :cage_size, primary_key: :size

  validates :size, presence: true
  validates :total_units, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :nightly_rate_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :currency, presence: true
end
