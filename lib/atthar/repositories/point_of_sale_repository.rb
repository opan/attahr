# frozen_string_literal: true

class PointOfSaleRepository < Hanami::Repository
  associations do
    belongs_to :org
    belongs_to :profile, foreign_key: :cashier_id
  end

  def all_by_org(org_id)
    aggregate(:profile, :org)
      .where(org_id: org_id)
      .map_to(PointOfSale)
      .to_a
  end

  def find_by_session_id(session_id)
    point_of_sales
      .where(session_id: session_id)
      .map_to(PointOfSale)
      .first
  end

  def find_open_pos_by_user(profile_id)
    point_of_sales
      .where(cashier_id: profile_id)
      .where(state: PointOfSale::STATES[:open])
      .where(Sequel.lit('org_id IS NOT NULL'))
      .map_to(PointOfSale)
      .first
  end

  def get_max_session_id_by_user(profile_id)
    point_of_sales
      .where(cashier_id: profile_id)
      .max(:session_id)
  end
end
