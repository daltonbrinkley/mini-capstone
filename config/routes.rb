Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/show_all_products_url" => "products#show_all_products_method"
end
