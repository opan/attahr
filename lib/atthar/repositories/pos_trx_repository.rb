# frozen_string_literal: true

class PosTrxRepository < Hanami::Repository
  associations do
    belongs_to :point_of_sale
    belongs_to :profile, foreign_key: :updated_by_id, as: :updated_by
  end

  def all_by_pos(pos_id)
    aggregate(:updated_by)
      .where(point_of_sale_id: pos_id)
      .map_to(PosTrx)
      .to_a
  end
end
