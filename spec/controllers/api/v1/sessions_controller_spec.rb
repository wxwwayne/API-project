require 'spec_helper'

describe Api::V1::SessionsController do
  describe "POST #create" do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      before :each do
        credentials = { email: user.email, password: "password" }
        post :create, session: credentials
      end
      it "returns the user of given credentials" do
        user.reload
        expect(json_response[:user][:auth_token]).to eq(user.auth_token)
      end

      it { is_expected.to respond_with 200 }
    end

    context 'with invalid credentials' do
      before :each do
        credentials = { email: user.email, password: "invalid" }
        post :create, session: credentials
      end
      it "returns errors json" do
        expect(json_response[:errors]).to include("Invalid email or password")
      end
      it { is_expected.to respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before :each do
      user = create(:user)
      sign_in user
      delete :destroy, id: user.auth_token
    end

    it { is_expected.to respond_with 204 }
  end
end
