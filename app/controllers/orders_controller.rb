class OrdersController < ApplicationController
  def index
    client = Elasticsearch::Client.new log: true, host: 'elasticsearch'
    response = client.get(index: 'shop', id: session[:shopify])['_source']['orders'].to_json
    render json: response
  end
end
