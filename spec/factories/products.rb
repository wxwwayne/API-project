FactoryGirl.define do
  factory :product do
    title { FFaker::Product.product_name }
    price { rand()*100 }
    published false
    user
    factory :invalid_product do
      price "one hundred"
    end
  end

end
