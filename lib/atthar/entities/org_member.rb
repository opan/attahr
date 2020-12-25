require_relative './profile'
require_relative './org_member_role'

class OrgMember < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :org_id, Types::Int
    attribute :org_member_role_id, Types::Int
    attribute :profile_id, Types::Int
    attribute :created_at, Types::DateTime
    attribute :updated_at, Types::DateTime

    attribute :org, Types::Entity(Org)
    attribute :profile, Types::Entity(Profile)
    attribute :org_member_role, Types::Entity(OrgMemberRole)
  end
end
