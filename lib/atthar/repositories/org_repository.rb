class OrgRepository < Hanami::Repository
  associations do
    has_many :org_members
    has_many :profiles, through: :org_members
  end

  def all_by_member(member_id, page: 1, per: 10)
    orgs
      .qualified
      .join(org_members)
      .where(org_members[:profile_id].qualified.is(member_id))
      .map_to(Org)
      .to_a
  end

  def find_by_member_ids(member_ids)
    orgs
      .qualified
      .join(org_members)
      .where(org_members[:id].qualified.in(member_ids))
      .map_to(Org)
      .to_a
  end

  def find_by_id_and_member(id, member_id)
    orgs
      .qualified
      .join(org_members)
      .where(orgs[:id].qualified.is(id))
      .where(org_members[:profile_id].is(member_id))
      .limit(1)
      .map_to(Org)
      .one
  end

  def is_founder?(profile_id)
    orgs
      .qualified
      .where(created_by_id: profile_id)
      .count > 0
  end

  def is_main?(id)
    orgs
      .where(id: id, is_root: true)
      .count > 0
  end
end
