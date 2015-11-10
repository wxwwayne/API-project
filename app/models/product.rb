class Product < ActiveRecord::Base
  validates :user_id, :title, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 },
    presence: true

  belongs_to :user
end
