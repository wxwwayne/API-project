class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!

  def index
    orders = current_user.orders.page(params[:page]).per(params[:per_page])
    render json: orders, meta: pagination(orders, params[:per_page])
  end

  def show
    order = current_user.orders.find(params[:id])
    respond_with order
  end

  def create
    order = current_user.orders.build
    order.build_placements_with_product_ids_and_quantities(params[:order][:product_ids_and_quantities])
    if order.save
      order.reload
      OrderMailer.delay.send_confirmation(order)
      render json: order, status: 201, location: [:api, current_user, order]
    else
      render json: { errors: order.errors }, status: 422
    end
  end
end

# def order_params
#   params.require(:order).permit(:product_ids => [])
# end
