# frozen_string_literal: true

Factory.define(:pos_trx) do |f|
  f.sequence(:trx_id) { |n| "trx-#{n}" }
  f.state { PosTrx::STATES[:open] }
  f.association(:point_of_sale)
  f.timestamps
end
