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
end
