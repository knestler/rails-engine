FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.department }
    unit_price { Faker::Commerce.price }
    merchant_id { Faker::Company.id }
  end
end
