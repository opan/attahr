class OrgMemberRepository < Hanami::Repository
  associations do
    belongs_to :org
    belongs_to :org_member_role
    belongs_to :profile
  end
end
