class V1::ProductsController < ApplicationController
  def index
    products = Product.all
    render json: products.as_json
  end

  def show
    product_id = params["id"]
    product = Product.find_by(id: product_id)
    render json: product.as_json
  end

  def create
    product = Product.new(
      name: "Beagle"
      price: 500
      image_url: "https://i.ytimg.com/vi/bx7BjjqHf2U/maxresdefault.jpg"
      description: "Cute male beagle puppy, looking for a new home!  Great around families!"
      )
    product.save
    render json: product.as_json
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