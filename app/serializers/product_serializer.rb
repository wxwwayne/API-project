class ProductSerializer < ActiveModel::Serializer
  cached
  attributes :id, :title, :price, :published, :quantity
  has_one :user
  def cache_key
    [object, scope]
  end
end
