Factory.define(:org) do |f|
  f.sequence(:name) { |n| "org-#{n}" }
  f.display_name { fake(:name) }
  f.address { fake(:addresss, :street_address) }
  f.phone_numbers { fake(:phone_number, :cell_phone) }
  f.is_root false
  f.timestamps
end
