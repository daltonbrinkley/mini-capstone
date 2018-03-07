class ProductsController < ApplicationController
  def show_all_products_method
    product = Product.all
    render json: product.as_json
  end
end
