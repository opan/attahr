class UserRepository < Hanami::Repository
  associations do
    has_one :profile
  end

  def create_with_profile(data)
    assoc(:profile).create(data)
  end

  def all_with_profile
    users.left_join(:profiles)
  end

  def find_by_email(email)
    users.where(email: email).limit(1).first
  end
end
