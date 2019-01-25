class AddProductsToShops < ActiveRecord::Migration[5.1]
  def change
    add_column :shops, :products, :jsonb, array: true, default: []
  end
end
