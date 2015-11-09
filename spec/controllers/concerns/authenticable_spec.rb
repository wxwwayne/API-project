require "spec_helper"

class Authentication
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  let(:user) { create(:user) }
  subject { authentication }

  describe "#current_user" do
    before do
      request.headers["Authorization"] = user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end
    it "returns the user from authentication header" do
      expect(authentication.current_user.auth_token).to eq(user.auth_token)
    end
  end

  describe "#authenticate_with_token" do
    before do
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:response_code).and_return(401)
      allow(response).to receive(:body).and_return({ "errors" => "Not authenticated" }.to_json)
      allow(authentication).to receive(:response).and_return(response)
    end

    it "renders errors json" do
      expect(json_response[:errors]).to eq("Not authenticated")
    end

    it { is_expected.to respond_with 401 }
  end
end
