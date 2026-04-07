class DashboardController < ApplicationController
  def index
    @today = Date.current

    # "Current" bookings overlap today's date (inclusive).
    @current_bookings = Booking
      .where("start_date <= ? AND end_date >= ?", @today, @today)
      .includes(:customer, :pets)
      .order(:start_date)

    @bookings_usage_by_cage = @current_bookings.group(:cage_size).count

    # Total configured inventory for each cage size.
    @cage_inventory_by_size = Cage.all.index_by(&:size)

    @cage_usage_rows = %w[small medium large].map do |size|
      cage = @cage_inventory_by_size[size]
      total = cage&.total_units.to_i
      booked = @bookings_usage_by_cage[size].to_i
      {
        size: size,
        total: total,
        booked: booked,
        available: [total - booked, 0].max
      }
    end
  end
end

