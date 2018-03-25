class V1::OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    orders = current_user.orders
    render json: orders.as_json
  end

  def create
    # product = Product.find_by(id: params[:product_id])
    # calculated_subtotal = product.price * params[:quantity].to_i

    # calculated_subtotal = 0
    # index = 0

    # carted_products.length.times do
    #   calculated_subtotal = calculated_subtotal + carted_products[index].product.price
    #   index = index + 1
    # end

    carted_products = current_user.carted_products.select { |carted_product| carted_product.status == "carted" }

    calculated_subtotal = carted_products.map { |carted_product| carted_product.product.price * carted_product.quantity }.sum

    calculated_tax = calculated_subtotal * 0.09
    calculated_total = calculated_subtotal + calculated_tax

    order = Order.new(
        user_id: current_user.id,
        subtotal: calculated_subtotal,
        tax: calculated_tax,
        total: calculated_total
        )
    order.save

    carted_products.each do |carted_product|
      carted_product.status = "complete"
      carted_product.order_id = order.id
      carted_product.save
    end

    render json: order.as_json

    # current_user.carted_products.select { |carted_product| carted_product[:status] = "carted"}

  end
end
