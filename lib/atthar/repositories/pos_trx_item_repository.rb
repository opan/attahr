# frozen_string_literal: true

class PosTrxItemRepository < Hanami::Repository
  associations do
    belongs_to :product
    belongs_to :product_category
  end

  def find_by_pos_trx(pos_trx_id)
    aggregate(:product, :product_category)
      .where(pos_trx_id: pos_trx_id)
      .map_to(PosTrxItem)
      .to_a
  end
end
