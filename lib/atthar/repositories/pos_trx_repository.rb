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

  def find_by_trx_id(trx_id)
    pos_trxes
      .where(trx_id: trx_id)
      .map_to(PosTrx)
      .one
  end

  def find_open_by_pos(pos_id)
    pos_trxes
      .where(point_of_sale_id: pos_id)
      .where(state: PosTrx::STATES[:open])
      .order(Sequel.desc(:created_at))
      .map_to(PosTrx)
      .one
  end

  def find_pending_by_pos(pos_id)
    pos_trxes
      .where(point_of_sale_id: pos_id)
      .where(state: PosTrx::STATES[:pending])
      .order(Sequel.desc(:created_at))
      .map_to(PosTrx)
      .to_a
  end

  def get_max_trx_id_by_pos(pos_id)
    pos_trxes
      .where(point_of_sale_id: pos_id)
      .max(:trx_id)
  end
end
