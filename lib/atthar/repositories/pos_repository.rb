class PosRepository < Hanami::Repository
  associations do
    belongs_to :org
  end

  def find_by_session_id(session_id)
    pos
      .where(session_id: session_id)
      .map_to(Pos)
      .to_a
  end
end
