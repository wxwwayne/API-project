require 'spec_helper'

describe Placement do
  let(:placement) { build(:placement) }
  subject { placement }
  it { should respond_to :order_id }
  it { should respond_to :product_id }
  it { should respond_to :quantity }

  it { should belong_to :order }
  it { should belong_to :product }

  describe "#decrement_product_quantity" do
    it "decrease the quantity of product by the placement quantity" do
      product = placement.product
      expect{placement.decrement_product_quantity!}.to change{product.quantity}.by(-placement.quantity)
    end
  end
end
