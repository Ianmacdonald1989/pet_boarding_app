class Booking < ApplicationRecord
  belongs_to :customer
  # Link to cage inventory row via the `cage_size` enum value.
  belongs_to :cage, foreign_key: :cage_size, primary_key: :size, optional: true
  has_many :pets, dependent: :destroy
  accepts_nested_attributes_for :pets, allow_destroy: true

  enum cage_size: { small: 'small', medium: 'medium', large: 'large' }

  # Small -> Medium -> Large ordering for business-rule comparisons.
  CAGE_ORDER = { 'small' => 0, 'medium' => 1, 'large' => 2 }.freeze

  before_validation :set_cage_size

  validates :customer_id, :start_date, :end_date, presence: true
  validates :cage_size, presence: true
  validates_associated :pets
  validate :start_date_is_not_after_end_date
  validate :must_have_pets
  validate :pet_types_supported
  validate :cage_availability

  # Business rule entry point requested by the prompt.
  # Calculates the required cage size based on booking's pets.
  def calculate_required_cage_size
    required_sizes = pets.map { |pet| cage_size_for_pet(pet) }
    return nil if required_sizes.empty?

    # If we cannot determine the cage size for any pet line, we treat the
    # entire booking as invalid (so staff can fix the input).
    return nil if required_sizes.any?(&:nil?)

    required_sizes.max_by { |size| CAGE_ORDER.fetch(size) }
  end

  private

  def cage_size_for_pet(pet)
    pet_type = pet.pet_type.to_s.strip.downcase
    quantity = pet.quantity.to_i
    pet_size = pet.pet_size.to_s.strip.downcase

    if pet_type.include?('guinea pig')
      quantity >= 2 ? 'medium' : 'small'
    elsif pet_type.include?('dog')
      # Large dog -> large kennel. We allow staff to either enter
      # `pet_size: large` or encode it in `pet_type` (e.g. "large dog").
      if pet_size == 'large' || pet_type.include?('large')
        'large'
      else
        'medium'
      end
    elsif pet_type.include?('cat')
      'medium'
    elsif pet_type.include?('hamster')
      'small'
    else
      # Unknown pet types are rejected at the booking level.
      nil
    end
  end

  def set_cage_size
    self.cage_size = calculate_required_cage_size
  end

  def must_have_pets
    if pets.blank?
      errors.add(:base, 'A booking must include at least one pet.')
    end
  end

  def pet_types_supported
    return if pets.blank?

    # We call the same business-rule method used to compute `cage_size`,
    # but only to provide a clearer error for unsupported pet types.
    if calculate_required_cage_size.nil?
      errors.add(:base, 'Unsupported pet type. Supported: guinea pig, dog, cat, hamster.')
    end
  end

  def start_date_is_not_after_end_date
    return if start_date.blank? || end_date.blank?

    if start_date > end_date
      errors.add(:end_date, 'must be on or after the start date')
    end
  end

  # Prevents overbooking by ensuring overlapping bookings for the same required
  # cage size do not exceed the available inventory for those dates.
  def cage_availability
    return if start_date.blank? || end_date.blank? || cage_size.blank?

    cage_inventory = Cage.find_by(size: cage_size)
    total_units = cage_inventory&.total_units.to_i

    if total_units <= 0
      errors.add(:base, "No #{cage_size} cages are configured in inventory.")
      return
    end

    overlapping_bookings = Booking
      .where(cage_size: cage_size)
      .where.not(id: id)
      .where('start_date <= ? AND end_date >= ?', end_date, start_date)
      .count

    if overlapping_bookings >= total_units
      errors.add(:base, "Not enough #{cage_size} cages available for those dates.")
    end
  end
end
