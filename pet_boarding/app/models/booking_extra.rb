class BookingExtra < ApplicationRecord
  belongs_to :booking

  validates :description, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :currency, presence: true

  def line_total_cents
    quantity.to_i * unit_price_cents.to_i
  end
end

