class CreatePets < ActiveRecord::Migration[6.1]
  def change
    create_table :pets do |t|
      # `pets` are created before `bookings` (timestamp-wise) in this scaffold,
      # so we avoid a hard FK constraint here to keep migrations working.
      t.references :booking, null: false
      t.string :pet_type
      t.string :pet_size
      t.integer :quantity

      t.timestamps
    end
  end
end
