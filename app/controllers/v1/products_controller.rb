class V1::ProductsController < ApplicationController
  def index
    products = Product.all
    render json: products.as_json
  end

  def show_all_products_method
    product = Product.all
    render json: product.as_json
  end

  def show_first_product_method
    product = Product.first
    render json: product.as_json
  end


end