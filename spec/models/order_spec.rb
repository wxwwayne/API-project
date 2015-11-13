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
    before :each do
      product_1 = create(:product, price: 80)
      product_2 = create(:product, price: 100)
      @order = build(:order, product_ids: [product_1.id, product_2.id])
    end
    it "rerurns the total amount to be paied" do
      expect{ @order.set_total! }.to change{ @order.total }.from(0).to(180)
    end
  end
end
