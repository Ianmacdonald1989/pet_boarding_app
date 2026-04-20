class CreateBookingExtras < ActiveRecord::Migration[6.1]
  def change
    create_table :booking_extras do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :description, null: false
      t.integer :quantity, default: 1, null: false
      t.integer :unit_price_cents, default: 0, null: false
      t.string :currency, default: "USD", null: false

      t.timestamps
    end
  end
end

