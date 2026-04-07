class CreateCages < ActiveRecord::Migration[6.1]
  def change
    create_table :cages do |t|
      t.string :size
      t.integer :total_units

      t.timestamps
    end
  end
end
