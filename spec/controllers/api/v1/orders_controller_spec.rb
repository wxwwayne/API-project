require 'spec_helper'

describe Api::V1::OrdersController do
  describe "GET #index" do
    before :each do
      user = create(:user)
      api_authorization_header user.auth_token
      4.times do
        create(:order, user: user)
      end
      get :index, user_id: user.id
    end

    it "returns record of the user" do
      order_response = json_response[:orders]
      expect(order_response.count).to eq(4)
    end

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before :each do
      user = create(:user)
      api_authorization_header user.auth_token
      @product = create(:product)
      @order = create(:order, user: user, product_ids: [@product.id])
      get :show, user_id: user, id: @order
    end
    it "returns the order in json format" do
      order_response = json_response[:order]
      expect(order_response[:id]).to eq(@order.id)
    end
    it { should respond_with 200 }

    it "returns the total of the order" do
      order_response = json_response[:order]
      expect(order_response[:total]).to eq(@product.price.to_s)
    end
    it "returns the products in the order" do
      order_response = json_response[:order]
      expect(order_response[:products].count).to be 1
    end
  end

  describe "POST #create" do
    before :each do
      user = create(:user)
      api_authorization_header user.auth_token
      @product_1 = create(:product)
      product_2 = create(:product)
      order_params = { product_ids_and_quantities: [[@product_1.id, 1], [product_2.id, 2]] }
      # order_params ={ product_ids: [product_1.id, product_2.id] }
      post :create, user_id: user, order: order_params
    end
    it "returns the order just created" do
      order_response = json_response[:order]
      expect(order_response[:id]).to be_present
    end

    it "decrements the quantity of product in your order" do
      expect(@product_1.reload.quantity).to eq(4)
    end

    it "embeds the two products into the order" do
      order_response = json_response[:order]
      expect(order_response[:products].count).to eq(2)
    end

    it { should respond_with 201 }
  end
end
