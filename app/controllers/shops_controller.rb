class ShopsController < ShopifyApp::AuthenticatedController
  def activate
    @shop = Shop.find(session[:shopify])
    session = ShopifyAPI::Session.new(@shop.shopify_domain, @shop.shopify_token)
    ShopifyAPI::Base.activate_session(session)
    charge = ShopifyAPI::RecurringApplicationCharge.create name: '>500 products deleted', price: 5.0, return_url: shops_callback_url
    @confirmation_url = charge.confirmation_url
  end

  def activate_and_redirect
    activate
    redirect_to @confirmation_url
  end

  def charge_declined
    @shop = Shop.find(session[:shopify])
  end

  def callback
    @shop = Shop.find(session[:shopify])
    session = ShopifyAPI::Session.new(@shop.shopify_domain, @shop.shopify_token)
    ShopifyAPI::Base.activate_session(session)
    return redirect_to charge_declined_path if ShopifyAPI::RecurringApplicationCharge.first.status == "declined"
    ShopifyAPI::RecurringApplicationCharge.first.activate
    flash[:info] = 'Thank you for signing up.'
    redirect_to root_path
  end
end