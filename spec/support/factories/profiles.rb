Factory.define(:profile) do |f|
  f.sequence(:name) { |n| "name-#{n}" }
  f.association(:user)
  f.timestamps
end
