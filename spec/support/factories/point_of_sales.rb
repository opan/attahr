# frozen_string_literal: true

Factory.define(:point_of_sale) do |f|
  f.sequence(:session_id) { |n| "session-#{n}" }
  f.sequence(:cashier_id) { |n| "cashier-#{n}" }
  f.association(:org)
  f.timestamps
end
