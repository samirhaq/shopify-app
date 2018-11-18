Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  post 'home/create_order' => 'home#create_order'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
