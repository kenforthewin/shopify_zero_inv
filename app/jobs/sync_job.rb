class SyncJob
  CYCLE = 0.5
  def perform(shop_id)
    client = Elasticsearch::Client.new log: true, host: 'elasticsearch'
    @shop = Shop.find(shop_id)
    session = ShopifyAPI::Session.new(@shop.shopify_domain, @shop.shopify_token)
    ShopifyAPI::Base.activate_session(session)
    sync_objects(ShopifyAPI::Product) do |products|
      # orders.each do |order|
        # Order.create shop_id: shop_id, body: order
      # end
      client.index index: 'shop', id: shop_id, type: 'page_body', body: {
        products: products
      }
    end
    # sync_objects(ShopifyAPI::Customer) do |customers|
    #   customers.each do |customer|
    #     Customer.create shop_id: shop_id, body: customer
    #   end
    # end
    # @shop.update last_synced_at: DateTime.now
  end

  private

  def sync_objects(shopify_class)
    object_count = shopify_class.count
    page_count = (object_count / 250.0).ceil
    start_time = Time.now
    1.upto(page_count) do |page|
      unless page == 1
        stop_time = Time.now
        processing_duration = stop_time - start_time
        wait_time = (CYCLE - processing_duration).ceil
        sleep wait_time if wait_time > 0
        start_time = Time.now
      end

      if @shop.last_synced_at.present?
        objects = shopify_class.find( :all, :params => { :limit => 250, :page => page, created_at_min: @shop.last_synced_at } )
      else
        objects = shopify_class.find( :all, :params => { :limit => 250, :page => page } )
      end
      yield objects
    end
  end
end