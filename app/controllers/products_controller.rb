class ProductsController < ShopifyApp::AuthenticatedController
  before_action :authorize_payments
  def index
  end

  def sync
    SyncJob.perform_async(session[:shopify])
    render json: {ok: true}.to_json
  end

  def get_products
    @shop = Shop.find(session[:shopify])
    products = @shop.products
    products ||= []
    products = products.select{ |product| product['variants'].any? { |variant| variant['inventory_quantity'] == 0 } }
    products_dt = []
    products.each do |product|
      product['variants'].select{|variant| variant['inventory_quantity'] == 0}.each do |variant|
        variant_check = "<input type='checkbox' data-name=#{variant['id']} />&nbsp;"
        products_dt << [ variant_check, product['title'], variant['title'], variant['sku'], variant['created_at'][0..9], variant['inventory_quantity'] ]
      end
    end
    render json: products_dt.to_json
  end

  def destroy_zero
    DeleteJob.perform_async(session[:shopify], params[:products])
    render json: {ok: true}.to_json
  end

  private

  def authorize_payments
    @shop = Shop.find(session[:shopify])
    session = ShopifyAPI::Session.new(@shop.shopify_domain, @shop.shopify_token)
    ShopifyAPI::Base.activate_session(session)
    payment = ShopifyAPI::RecurringApplicationCharge.all.first
    if @shop.destroyed_products_count > 50
      if !payment || payment.status != 'active'
        flash[:notice] = 'You\'ve deleted over 50 products. Please upgrade your plan.'
        return redirect_to activate_path
      end
    end
    @active = payment && payment.status == 'active'
  end
end
