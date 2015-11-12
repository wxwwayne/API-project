class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!

  def index
    orders = current_user.orders
    respond_with orders
  end
end
