class UserRepository < Hanami::Repository
  associations do
    has_one :profile
  end

  def create_with_profile(data)
    assoc(:profile).create(data)
  end

  def update_with_profile(user, data)
    assoc(:profile, user).update(data)
  end

  def all_with_profile
    aggregate(:profiles)
  end

  def find_by_email(email)
    users.where(email: email).limit(1).first
  end

  def find_by_email_with_profile(email)
    aggregate(:profile).where(email: email).map_to(User).one
  end
end
