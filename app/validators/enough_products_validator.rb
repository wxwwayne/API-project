class EnoughProductsValidator < ActiveModel::Validator
  def validate(record)
    record.placements.each do |placement|
      product = placement.product
      if product.quantity < placement.quantity
        record.errors["#{product.title}"] << "Is out of stock, only #{product.quantity} left"
      end
    end
  end
end
