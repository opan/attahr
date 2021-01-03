class OrgMemberRoleRepository < Hanami::Repository
  def get(role = 'staff')
    org_member_roles.where(name: role).limit(1).map_to(OrgMemberRole).one
  end
end
