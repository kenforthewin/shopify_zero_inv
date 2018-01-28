class AddLastSyncedAtToShops < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :last_synced_at, :datetime
  end
end
