class DeleteJob
  include Sidekiq::Worker

  CYCLE = 0.5
  def perform(shop_id, products)
    @shop = Shop.find(shop_id)
    destroy_count = 0
    product_destroy_count = 0
    start_time = Time.now
    session = ShopifyAPI::Session.new(@shop.shopify_domain, @shop.shopify_token)
    ShopifyAPI::Base.activate_session(session)
    total = products.count
    count = 0
    products.each do |product|
      count += 1
      ProductChannel.broadcast_to(shop_id, message: "products_deleting", count: count, total: total)
      begin
        variant = ShopifyAPI::Variant.find(product)
        if variant.title == 'Default Title'
          product_destroy_count += 1 if ShopifyAPI::Product.find(variant.product_id).destroy
        else
          destroy_count += 1 if variant.destroy
        end
      rescue
      end

      if destroy_count != 1
        stop_time = Time.now
        processing_duration = stop_time - start_time
        wait_time = (CYCLE - processing_duration).ceil
        sleep wait_time if wait_time > 0
        start_time = Time.now
      end
    end

    @shop.update(destroyed_products_count: @shop.destroyed_products_count + destroy_count + product_destroy_count)
    SyncJob.new.perform(shop_id)
    ProductChannel.broadcast_to(shop_id, message: "products_deleted")
  end
end
