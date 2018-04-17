class V1::ProductsController < ApplicationController
  before_action :authenticate_admin, except: [:index, :show]
  # before_action :authenticate_user

  def index
    products = Product.all

    search_terms = params["input_name_search"]
    if search_terms
      products = products.where("name ILIKE ?", "%#{search_terms}%")
    end

    i_should_sort_by_price = params[:sort_by_price]
    if i_should_sort_by_price
      products = products.order(price: :asc)
    else
      products = products.order(id: :asc)
    end

    input_category = params[:category]
    if input_category
      category = Category.find_by(name: input_category)
      products = category.products
    end

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
    # product.image_url = params["input_url"] || product.image_url
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
      # image_url: params["input_url"],
      description: params["input_description"],
      supplier_id: 1
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
    render json: {message: "Product successfully deleted!!!" }
  end
end