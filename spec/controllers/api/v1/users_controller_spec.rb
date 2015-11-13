require 'spec_helper'

describe Api::V1::UsersController do
  describe "GET #show" do
    before(:each) do
      @user = create(:user)
      get :show, id: @user
    end

    it "returns a hash of user information" do
      user_response = json_response[:user]
      expect(user_response[:email]).to eq(@user.email)
    end

    it "has the products ids as the embeded object" do
      user_response = json_response[:user]
      expect(user_response[:product_ids]).to eq []
    end

    it { is_expected.to respond_with 200 }
  end


  describe "GET #index" do
    before :each do
      4.times { create(:user) }
      get :index
    end
    it "returns the records from database" do
      user_response = json_response[:users]
      expect(user_response.count).to eq 4
    end

    it "has product ids as embeded object" do
      user_response = json_response[:users]
      user_response.each do |user_response|
        expect(user_response[:product_ids]).to eq []
      end
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context 'with valid attributes' do
      before(:each) do
        @user = attributes_for(:user)
        post :create, user: @user
      end

      it "renders the user just created" do
        user_response = json_response[:user]
        expect(user_response[:email]).to eq(@user[:email])
      end
      it { is_expected.to respond_with 201 }
    end

    context 'with invalid attributes' do
      before :each do
        @user = attributes_for(:invalid_user)
        post :create, user: @user
      end
      it "renders errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders why the errors happen" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { is_expected.to respond_with 422 }
    end
  end

  describe "PUT #update" do
    before :each do
      @user = create(:user)
      api_authorization_header(@user.auth_token)
    end
    context "with valid attributes" do
      before :each do
        @new_attributes = attributes_for(:user)
        put :update, id: @user, user: @new_attributes
      end

      it "renders the user just updated" do
        user_response = json_response[:user]
        expect(user_response[:email]).to eq(@new_attributes[:email])
      end
      it { is_expected.to respond_with 200 }
    end

    context 'with invalid attributes' do
      before :each do
        @new_attributes = attributes_for(:invalid_user)
        put :update, id: @user, user: @new_attributes
      end
      it "renders errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end
      it { is_expected.to respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @user = create(:user)
      api_authorization_header(@user.auth_token)
      delete :destroy, id: @user
    end

    it { is_expected.to respond_with 204 }
  end
end
