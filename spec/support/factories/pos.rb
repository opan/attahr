# frozen_string_literal: true

Factory.define(:pos) do |f|
  f.sequence(:session_id) { |n| "session-#{n}" }
  f.sequence(:cashier_id) { |n| "cashier-#{n}" }
  f.association(:org)
  f.timestamps
end
