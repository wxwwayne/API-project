require 'spec_helper'

describe Api::V1::ProductsController, type: :controller do
  describe "GET #show" do
    before :each do
      @product = create(:product)
      get :show, id: @product
    end
    it "returns a hash of the information" do
      product_response = json_response[:product]
      expect(product_response[:title]).to eq(@product.title)
    end

    it "has the user as a embeded object" do
      product_response = json_response[:product]
      expect(product_response[:user][:email]).to eq(@product.user.email)
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before :each do
      4.times { create(:product) }
    end

    context 'when not receiving product_ids parameters' do
      before :each do
        get :index
      end
      it "returns the records from database" do
        product_response = json_response[:products]
        expect(product_response.count).to eq 4
      end

      it "returns the user in each product" do
        product_response = json_response[:products]
        product_response.each do |product_response|
          expect(product_response[:user]).to be_present
        end
      end

      it_behaves_like "paginated list"

      it { should respond_with 200 }
    end

    context 'when receiving product_ids parameters' do
      before :each do
        @user = create(:user)
        4.times { create(:product, user: @user) }
        get :index, product_ids: @user.product_ids
      end
      it "returns the products that belongs to the @user" do
        product_response = json_response[:products]
        # puts product_response
        expect(product_response.count).to eq(4)
        product_response.each do |product_response|
          expect(product_response[:user][:email]).to eq(@user.email)
        end
      end
    end

    context 'when receive other search params' do
      before :each do
        @user = create(:user)
        @product = create(:product, title: "goodstaff", user: @user)
        4.times { create(:product, user: @user) }
        get :index, keyword: @product.title
      end

      it "returns the product that matches the title" do
        product_response = json_response[:products]
        expect(product_response[0][:title]).to eq @product.title
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:user) { create(:user) }
      let(:product) { attributes_for(:product) }
      before :each do
        api_authorization_header user.auth_token
        post :create, user_id: user.id, product: product
      end

      it "renders the product just created" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eq(product[:title])
      end
      it { should respond_with 201 }
    end

    context 'with invalid attributes' do
      let(:user) { create(:user) }
      let(:invalid_product) { attributes_for(:invalid_product) }
      before :each do
        api_authorization_header user.auth_token
        post :create, user_id: user.id, product: invalid_product
      end

      it "renders errors json" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end
      it { should respond_with 422 }
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user) }
    let(:product) { create(:product, user: user) }
    let(:new_attributes) { attributes_for(:product) }
    let(:invalid_attributes) { attributes_for(:invalid_product) }
    before(:each) { api_authorization_header user.auth_token }

    context "with valid attributes" do
      before :each do
        patch :update, user_id: user,
          id: product, product: new_attributes
      end

      it "renders json of product just updated" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eq(new_attributes[:title])
      end
      it { should respond_with 200 }
    end

    context "with invalid attributes" do
      before :each do
        patch :update, user_id: user,
          id: product, product: invalid_attributes
      end

      it "renders errors json" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include("is not a number")
      end
      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user) }
    let(:product) { create(:product, user: user) }
    before(:each) do
      api_authorization_header user.auth_token
      delete :destroy, user_id: user, id: product
    end

    it { should respond_with 204 }
  end
end
