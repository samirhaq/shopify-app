ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "ee5fd9e6d5160e8c9fe4a3dd8381a0bc"
  config.secret = "0769e5b8b04940e91dcb58fbff1551c9"
  config.scope = "read_products" # Consult this page for more scope options:
                                 # https://help.shopify.com/en/api/getting-started/authentication/oauth/scopes
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
