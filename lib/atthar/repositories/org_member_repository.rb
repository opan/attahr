class OrgMemberRepository < Hanami::Repository
  associations do
    belongs_to :org
    belongs_to :org_member_role
    belongs_to :profile
  end

  def find_by_org(org_id, page: 1, per: 10)
    aggregate(:profile, :org_member_role)
      .where(org_id: org_id)
      .map_to(OrgMember)
      .to_a
  end

  def is_member?(org_id, profile_id)
    org_members
      .where(org_id: org_id)
      .where(profile_id: profile_id)
      .count > 0
  end

  def is_admin?(org_id, profile_id)
    org_members
      .join(org_member_roles)
      .where(org_id: org_id)
      .where(profile_id: profile_id)
      .where(org_member_roles[:name].qualified => 'admin')
      .count > 0
  end

  def delete_by_org_and_user(org_id, profile_id)
    org_members
      .where(org_id: org_id)
      .where(profile_id: profile_id)
      .delete
  end
end
