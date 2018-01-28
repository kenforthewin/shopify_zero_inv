class ShopsController < ShopifyApp::AuthenticatedController
  def activate
    @shop = Shop.find(session[:shopify])
    session = ShopifyAPI::Session.new(@shop.shopify_domain, @shop.shopify_token)
    ShopifyAPI::Base.activate_session(session)
    charge = ShopifyAPI::RecurringApplicationCharge.create name: '>500 products deleted', price: 5.0, return_url: shops_callback_url
    @confirmation_url = charge.confirmation_url
  end

  def callback
    @shop = Shop.find(session[:shopify])
    session = ShopifyAPI::Session.new(@shop.shopify_domain, @shop.shopify_token)
    ShopifyAPI::Base.activate_session(session)
    ShopifyAPI::RecurringApplicationCharge.first.activate
    flash[:notice] = 'Thank you for signing up.'
    redirect_to root_path
  end
end