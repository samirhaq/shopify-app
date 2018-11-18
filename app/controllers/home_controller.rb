class HomeController < ShopifyApp::AuthenticatedController
  
  def list
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)

    unless @webhooks.present?
      create_order
    end

  end

  def create_order
  # create webhook for order creation if it doesn't exist
    unless ShopifyAPI::Webhook.find(:all).any?
      webhook = {
        topic: 'orders/create',
        address: "https://#https://floating-tundra-99940.herokuapp.com/home/webhook/order_create",
        format: 'json'}

      ShopifyAPI::Webhook.create(webhook)
    end
  end
end
