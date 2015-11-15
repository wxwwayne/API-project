require 'spec_helper'

describe Order do
  let(:order) { build(:order) }
  subject { order }
  #Order model validation
  it { should respond_to(:total) }
  it { should respond_to(:user_id) }
  it { should validate_presence_of(:user_id) }
  # it { should validate_presence_of(:total) }
  # it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }

  it { should belong_to :user }

  it { should have_many(:products).through(:placements) }
  it { should have_many(:placements) }

  describe "#set_total!" do
    before :all do
      product_1 = create(:product, price: 80, quantity: 5)
      product_2 = create(:product, price: 100, quantity: 10)

      placement_1 = build(:placement, product: product_1, quantity: 5)
      placement_2 = build(:placement, product: product_2, quantity: 2)
      @order = build(:order)
      @order.placements << placement_1
      @order.placements << placement_2
    end
    it "rerurns the total amount to be paied" do
      expect{ @order.set_total! }.to change{ @order.total }.from(0).to(600)
    end
  end

  describe "#build_placements_with_product_and_ids_and_quantity" do
    before :each do
      product_1 = create(:product, price: 80, quantity: 5)
      product_2 = create(:product, price: 100, quantity: 10)
      @product_ids_and_quantities = [[product_1.id, 1], [product_2.id, 2]]
    end
    it "builds 2 placements for the order" do
      expect{ order.build_placements_with_product_ids_and_quantities(@product_ids_and_quantities) }.to change{ order.placements.size }.from(0).to(2)
    end
  end

  describe "#valid?" do
    before :all do
      product_1 = create(:product, price: 100, quantity: 5)
      product_2 = create(:product, price: 50, quantity:10)
      placement_1 = build(:placement, product: product_1, quantity: 2 )
      placement_2 = build(:placement, product: product_2, quantity: 11)

      @order = build(:order)
      @order.placements << placement_1
      @order.placements << placement_2
    end

    it "is invalid if the demand is over stock" do
      expect(@order).not_to be_valid
    end
  end
end
