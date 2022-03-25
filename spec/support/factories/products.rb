Factory.define(:product) do |f|
  f.association(:product_category)
  f.sequence(:name) { |n| "product-#{n}" }
  f.sku { fake(:alphanumeric, 8) }
  f.price { 10000 }
  f.stock { 1 }
  f.timestamps
end
