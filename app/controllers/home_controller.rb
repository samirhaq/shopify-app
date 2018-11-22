

class HomeController < ShopifyApp::AuthenticatedController
  
  def index
    #ShopifyAPI::Webhook.delete(436033028211)
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
    @vendors = parse_order

    unless @webhooks.present?
      create_order_webhook
    end

  end

  def create_order_webhook
  # create webhook for order creation if it doesn't exist
    ShopifyAPI::Webhook.create({
    topic: 'orders/create',
    address: "https://b82bc646.ngrok.io/webhook/order_create",
    format: 'json'})

  end

  def parse_order
    orders = ShopifyAPI::Order.find(:all, params: {limit: 10})
    order = orders.first
    line = order.line_items
    len = line.length
    vendors = Array.new
    for i in 0..(len - 1)
      for j in 0..(i)
        if line[i].vendor == line[j].vendor
          break
        end
      end
      if i == j
        vendors.push(line[i].vendor)
      end
    end

    return vendors
  end    


  def get_order
    header_hmac = request.headers["HTTP_X_SHOPIFY_HMAC_SHA256"]
    digest = OpenSSL::Digest.new("sha256")
    request.body.rewind
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SHARED_SECRET, request.body.read)).strip

    puts "header hmac: #{header_hmac}"
    puts "calculated hmac: #{calculated_hmac}"

    puts "Verified:#{ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, header_hmac)}"
    head :ok
  end

end
