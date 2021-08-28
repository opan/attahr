class OrgMemberRepository < Hanami::Repository
  associations do
    belongs_to :org
    belongs_to :org_member_role
    belongs_to :profile
  end

  def find_by_org(org_id, page: 1, per: 10)
    org_members
      .where(org_id: org_id)
      .map_to(OrgMember)
      .to_a
  end
end
