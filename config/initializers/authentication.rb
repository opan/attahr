class FailureApp
  def call(env)
    action = Web::Controllers::Sessions::New.new
    response = action.call(env)
    response[2] = [Web::Views::Sessions::New.render(action.exposures.merge(format: :html))]
    response
  end
end

Warden::Manager.before_failure do |env, opts|
  # Prepare something before_failure
end

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  repo = UserRepository.new
  user = repo.find_with_profile(id)
  user
end

Warden::Strategies.add(:password) do
  def valid?
    true
  end

  def authenticate!
    u = params.fetch('user', {})
    email = u['email']
    password = u['password']

    repo = UserRepository.new
    user = repo.find_by_email(email)

    if user.nil?
      fail!('User email or password is incorrect')
      return
    end

    if user && BCrypt::Password.new(user.password_hash) != password
      fail!('User email or password is incorrect')
      return
    end

    success!(user)
  end
end
