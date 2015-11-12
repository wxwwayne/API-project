require "spec_helper"

describe Product do
  let(:product) { build(:product) }
  subject { product }
  #Product model validation
  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:published) }
  it { should respond_to(:user_id) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should belong_to(:user) }

  #product placement association test
  it { should have_many :placements }
  it { should have_many(:orders).through(:placements) }

  #filter test
  describe ".filter_by_title" do
    before :each do
      @product1 = create(:product, title: "A plasma TV")
      @product2 = create(:product, title: "Fastest Laptop")
      @product3 = create(:product, title: "CD player")
      @product4 = create(:product, title: "LCD TV")
    end

    context "TV keywords sent" do
      it "returns products that match" do
        expect(Product.filter_by_title("TV").sort).to match_array [@product1, @product4]
      end
    end
  end

  describe ".above_or_equal_to_price" do
    before :each do
      @product1 = create(:product, price: 100)
      @product2 = create(:product, price: 200)
      @product3 = create(:product, price: 300)
      @product4 = create(:product, price: 400)
    end
    it "returns products that match" do
      expect(Product.above_or_equal_to_price(250).sort).to match_array [@product3, @product4]
    end
  end

  describe ".recent" do
    before :each do
      @product1 = create(:product)
      @product2 = create(:product)
      @product3 = create(:product)
      @product4 = create(:product)
    end
    it "returns the products most-recent-updated-first" do
      expect(Product.recent).to match_array [@product4,@product3,@product2,@product1]
    end
  end
  #search test
  describe ".search" do
    before(:each) do
      @product1 = create(:product, price: 100, title: "Plasma tv")
      @product2 = create(:product, price: 50, title: "Videogame console")
      @product3 = create(:product, price: 150, title: "MP3")
      @product4 = create(:product, price: 99, title: "Laptop")
    end

    context "when title 'videogame' are set" do
      it "returns an empty array" do
        search_hash = { keyword: "videogame"}
        expect(Product.search(search_hash)).to match_array [@product2]
      end
    end

    context "combination search is set" do
      it "returns the product that matches both params" do
        search_hash = { keyword: "tv", price: 50 }
        expect(Product.search(search_hash)).to match_array([@product1])
      end
    end

    context "when an empty hash is sent" do
      it "returns all the products" do
        expect(Product.search({})).to match_array([@product1, @product2, @product3, @product4])
      end
    end

    context "when product_ids is present" do
      it "returns the product from the ids" do
        search_hash = { product_ids: [@product1.id, @product2.id]}
        expect(Product.search(search_hash)).to match_array([@product1, @product2])
      end
    end
  end
end
