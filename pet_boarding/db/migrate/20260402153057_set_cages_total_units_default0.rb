class SetCagesTotalUnitsDefault0 < ActiveRecord::Migration[6.1]
  def change
    # Ensure inventory has a safe default.
    change_column_default :cages, :total_units, 0
  end
end
