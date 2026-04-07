class AddCageSizeToBookings < ActiveRecord::Migration[6.1]
  def change
    add_column :bookings, :cage_size, :string
    add_index :bookings, :cage_size
  end
end
