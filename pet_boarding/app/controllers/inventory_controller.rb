class InventoryController < ApplicationController
  SIZES = %w[small medium large].freeze

  def edit
    ensure_inventory_rows_exist!
    @cages_by_size = Cage.all.index_by(&:size)
  end

  def update
    ensure_inventory_rows_exist!

    updates = inventory_params.to_h

    Cage.transaction do
      SIZES.each do |size|
        next unless updates.key?(size)

        value = updates.fetch(size)
        total_units = Integer(value.fetch("total_units"))
        nightly_rate_cents = Integer(value.fetch("nightly_rate_cents"))

        Cage.find_by!(size: size).update!(total_units: total_units, nightly_rate_cents: nightly_rate_cents)
      rescue ArgumentError, TypeError
        raise ActiveRecord::RecordInvalid.new(Cage.new), "Invalid number for #{size}"
      end
    end

    redirect_to inventory_path, notice: "Inventory updated."
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    ensure_inventory_rows_exist!
    @cages_by_size = Cage.all.index_by(&:size)
    flash.now[:alert] = e.message.presence || "Could not update inventory."
    render :edit, status: :unprocessable_entity
  end

  private

  def ensure_inventory_rows_exist!
    SIZES.each do |size|
      Cage.find_or_create_by!(size: size) do |c|
        c.total_units = 0
      end
    end
  end

  def inventory_params
    params.fetch(:inventory, {}).permit(
      small: %i[total_units nightly_rate_cents],
      medium: %i[total_units nightly_rate_cents],
      large: %i[total_units nightly_rate_cents]
    )
  end
end

