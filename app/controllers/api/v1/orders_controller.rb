class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!

  def index
    orders = current_user.orders
    respond_with orders
  end

  def show
    order = current_user.orders.find(params[:id])
    respond_with order
  end

  def create
    order = current_user.orders.build(order_params)
    if order.save
      render json: order, status: 201, location: [:api, current_user, order]
    else
      render json: { errors: order.errors }, status: 422
    end
  end
end

def order_params
  params.require(:order).permit(:product_ids => [])
end
