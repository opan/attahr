class ProfileRepository < Hanami::Repository
  associations do
    belongs_to :user
    has_many :org_members
    has_many :orgs, through: :org_members
  end
end
