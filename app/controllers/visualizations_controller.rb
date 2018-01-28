class VisualizationsController < ShopifyApp::AuthenticatedController
  def dashboard

    @shop = Shop.find_by(shopify_domain: ShopifyAPI::Shop.current.domain)
    # @orders = client.get index: 'shop', id: session[:shopify]
  end
end
