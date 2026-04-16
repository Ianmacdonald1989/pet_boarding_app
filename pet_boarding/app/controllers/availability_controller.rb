class AvailabilityController < ApplicationController
  SIZES = %w[small medium large].freeze

  def show
    start_date = parse_date(params[:start_date])
    end_date = parse_date(params[:end_date])

    if start_date.nil? || end_date.nil?
      return render json: { ok: false, error: "start_date and end_date are required (YYYY-MM-DD)" }, status: :unprocessable_entity
    end

    if start_date > end_date
      return render json: { ok: false, error: "start_date must be on or before end_date" }, status: :unprocessable_entity
    end

    ensure_inventory_rows_exist!

    booked_by_size = Booking
      .where("start_date <= ? AND end_date >= ?", end_date, start_date)
      .group(:cage_size)
      .count

    cages_by_size = Cage.all.index_by(&:size)

    rows = SIZES.map do |size|
      total = cages_by_size.fetch(size).total_units.to_i
      booked = booked_by_size[size].to_i
      available = [total - booked, 0].max
      { size: size, total: total, booked: booked, available: available }
    end

    render json: { ok: true, start_date: start_date, end_date: end_date, rows: rows }
  end

  private

  def parse_date(value)
    return nil if value.blank?
    Date.iso8601(value)
  rescue ArgumentError
    nil
  end

  def ensure_inventory_rows_exist!
    SIZES.each do |size|
      Cage.find_or_create_by!(size: size) { |c| c.total_units = 0 }
    end
  end
end

