class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage

  has_many :orders
  has_many :customers
end
