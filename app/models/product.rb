class Product < ActiveRecord::Base
  validates :user_id, :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 },
    presence: true
  belongs_to :user
  has_many :orders, through: :placements
  has_many :placements

  scope :filter_by_title, lambda { |keyword|
    where("lower(title) LIKE ?", "%#{keyword.downcase}%") }

  scope :above_or_equal_to_price, lambda { |price|
    where("price>= ?", price) }

  scope :recent, -> { order :updated_at }

  def self.search(params = {})
    products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all
    products = products.filter_by_title(params[:keyword]) if params[:keyword]
    products = products.above_or_equal_to_price(params[:price].to_f) if params[:price]
    products = products.recent(params[:recent]) if params[:recent]
    return products
  end
end
