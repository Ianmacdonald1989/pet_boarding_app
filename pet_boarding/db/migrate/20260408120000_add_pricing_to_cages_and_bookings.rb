class AddPricingToCagesAndBookings < ActiveRecord::Migration[6.1]
  def change
    add_column :cages, :nightly_rate_cents, :integer, default: 0, null: false
    add_column :cages, :currency, :string, default: "USD", null: false

    add_column :bookings, :total_cents, :integer, default: 0, null: false
    add_column :bookings, :currency, :string, default: "USD", null: false
  end
end

