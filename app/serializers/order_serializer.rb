class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :user_id
  has_many :products, serializer: OrderProductSerializer
end
