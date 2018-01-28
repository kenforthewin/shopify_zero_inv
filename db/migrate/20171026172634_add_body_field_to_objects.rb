class AddBodyFieldToObjects < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :body, :jsonb
    add_column :customers, :body, :jsonb
  end
end
