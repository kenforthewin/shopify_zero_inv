class ProductsController < ShopifyApp::AuthenticatedController
  before_action :authorize_payments
  def index
    client = Elasticsearch::Client.new log: true, host: 'elasticsearch'
    @products = client.get(index: 'shop', id: session[:shopify])['_source']['products']
    @products ||= []
    @products = @products.select{ |product| product['variants'].any? { |variant| variant['inventory_quantity'] == 0 } }
  end

  def sync
    SyncJob.new.perform(session[:shopify])
    render json: {ok: true}.to_json
  end

  CYCLE = 0.5  
  def destroy_zero
    products = params[:products]
    destroy_count = 0
    product_destroy_count = 0
    start_time = Time.now

    products.each do |product|
      variant = ShopifyAPI::Variant.find(product)
      Rails.logger.debug product
      if variant.title == 'Default Title'
        product_destroy_count += 1 if ShopifyAPI::Product.find(variant.product_id).destroy
      else
        destroy_count += 1 if variant.destroy

      end
      if destroy_count != 1
        stop_time = Time.now
        processing_duration = stop_time - start_time
        wait_time = (CYCLE - processing_duration).ceil
        sleep wait_time if wait_time > 0
        start_time = Time.now
      end
    end
    @shop.update(destroyed_products_count: @shop.destroyed_products_count + destroy_count)
    response_text = "#{destroy_count} #{'variant'.pluralize(destroy_count)} and #{product_destroy_count} #{'product'.pluralize(product_destroy_count)} destroyed. Click 'Update Products' to check for any remaining."
    render json: {destroy_count: destroy_count, product_destroy_count: product_destroy_count, response_text: response_text}.to_json
  end

  private

  def authorize_payments
    @shop = Shop.find(session[:shopify])
    session = ShopifyAPI::Session.new(@shop.shopify_domain, @shop.shopify_token)
    ShopifyAPI::Base.activate_session(session)
    if @shop.destroyed_products_count > 500
      payment = ShopifyAPI::RecurringApplicationCharge.all.first
      if !payment || payment.status != 'active'
        flash[:notice] = 'You\'ve deleted over 500 products. Please upgrade your plan.'
        return redirect_to activate_path
      end
    end
  end
end
