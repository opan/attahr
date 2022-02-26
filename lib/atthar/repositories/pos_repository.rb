# frozen_string_literal: true

class PosRepository < Hanami::Repository
  associations do
    belongs_to :org
    belongs_to :profile, foreign_key: :cashier_id
  end

  def all_by_org(org_id)
    aggregate(:profile, :org)
      .where(org_id: org_id)
      .map_to(Pos)
      .to_a
  end

  def find_by_session_id(session_id)
    pos
      .where(session_id: session_id)
      .map_to(Pos)
      .to_a
  end
end
