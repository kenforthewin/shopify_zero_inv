class AddDestroyedProductsCountToShops < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :destroyed_products_count, :integer, default: 0
  end
end
