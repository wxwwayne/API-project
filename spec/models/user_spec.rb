require 'spec_helper'

describe User do
  let(:user) { build(:user) }

  subject { user }
  specify { is_expected.to respond_to :email }
  specify { is_expected.to respond_to :password }
  specify { is_expected.to respond_to :password_confirmation }
  specify { is_expected.to respond_to :auth_token }
  specify { is_expected.to be_valid }

  specify { is_expected.to validate_presence_of :email }
  specify { is_expected.to validate_presence_of :password }
  specify { is_expected.to validate_uniqueness_of :auth_token }
  specify { is_expected.to validate_confirmation_of :password }
  specify { is_expected.to allow_value('what@ever.com').for(:email) }
  it { should have_many(:products) }

  describe "#generate auth_token" do
    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      user.generate_authentication_token!
      expect(user.auth_token).to eq("auniquetoken123")
    end

    it "generates another token if one already taken" do
      one_user = create(:user, auth_token: "auniquetoken123")
      user.generate_authentication_token!
      expect(user.auth_token).not_to eq(one_user.auth_token)
    end
  end

  describe "#products association " do
    before do
      user.save
      3.times do
        create(:product, user: user)
      end
    end
    it "destroys associated products while user destroyed" do
      products = user.products
      user.destroy
      products.each do |product|
        expect(Product.find(product.id)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
