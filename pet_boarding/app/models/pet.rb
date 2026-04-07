class Pet < ApplicationRecord
  belongs_to :booking

  validates :pet_type, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Dogs: we infer "large" either from `pet_size` or from `pet_type`
  # (e.g. "large dog"). If the user typed "dog" but did not specify
  # the size, we require `pet_size`.
  validates :pet_size, presence: true, if: :dog_needs_size?

  private

  def dog_needs_size?
    type = pet_type.to_s.strip.downcase
    type.include?('dog') && !type.include?('large')
  end
end
