# frozen_string_literal: true

Factory.define(:pos_trx_item) do |f|
  f.association(:pos_trx)
  f.sequence(:name) { |n| "product-#{n}"}
  f.sequence(:product_id) { |n| n }
  f.sku { fake(:alphanumeric, 8) }
  f.barcode { fake(:alphanumeric, 12) }
  f.price { 1000 } 
  f.qty { 1 }
  f.timestamps
end
