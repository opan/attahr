class UserRepository < Hanami::Repository
  associations do
    has_one :profile
  end

  def create_with_profile(data)
    assoc(:profile).create(data)
  end

  def all_with_profile
    aggregate(:profiles).to_a
  end

  def find_by_email(email)
    users.where(email: email).limit(1).map_to(User).one
  end

  def find_by_email_with_profile(email)
    aggregate(:profile).where(email: email).map_to(User).one
  end

  def find_with_profile(id)
    aggregate(:profile).where(id: id).map_to(User).one
  end
end
