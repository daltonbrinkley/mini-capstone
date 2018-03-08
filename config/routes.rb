Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v1 do
    get "/show_all_products_url" => "products#show_all_products_method"
    get "/show_first_product_url" => "products#show_first_product_method"
  end
end
