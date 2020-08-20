class UserRepository < Hanami::Repository
  def find_by_email(email)
    users.where(email: email).limit(1).first
  end
end
