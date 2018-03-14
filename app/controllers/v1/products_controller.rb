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

  def update
    product_id = params["id"]
    product = Product.find_by(id: product_id)
    product.name = params["input_name"] || product.name
    product.price = params["input_price"] || product.price
    product.image_url = params["input_url"] || product.image_url
    product.description = params["input_description"] || product.input_description
    if product.save
      render json: product.as_json
    else
      render json: {errors: product.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def create
    product = Product.new(
      name: params["input_name"],
      price: params["input_price"],
      image_url: params["input_url"],
      description: params["input_description"]
      )
    if product.save
      render json: product.as_json
    else
      render json: {errors: product.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    product_id = params["id"]
    product = Product.find_by(id: product_id)
    product.destroy
    render json: {message: "Product successfully deleted!!!"}
  end
end