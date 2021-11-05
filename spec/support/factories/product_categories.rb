Factory.define(:product_category) do |f|
  f.sequence(:name) { |n| "product-category-#{n}" }
  f.timestamps
end
