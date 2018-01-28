class Order < ApplicationRecord
  belongs_to :shop

  # def self.top_vendors(shop_id)
  #   self.top_objects_from_record('vendor', 'line_items', 'orders', shop_id)
  # end

  # def self.top_products(shop_id)
  #   self.top_objects_from_record('name', "body -> 'line_items'", 'orders', shop_id)    
  # end

  # def self.keys(shop_id)
  #   self.top_level_keys('body', 'orders', shop_id)
  # end
end
