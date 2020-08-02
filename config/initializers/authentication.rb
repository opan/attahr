require 'warden'

class FailureApp
  def call(env)
    action = Web::Controllers::Sessions::New.new
    response = action.call(env)
    response[2] = Web::Views::Sessions::New.render(action.exposures.merge(format: :html))
    response
  end
end

Warden::Manager.serialize_into_session do |user|
  puts "serialize_into_session"
  puts user
  user
end

Warden::Manager.serialize_from_session do |id|
  puts id
  id
end

Warden::Strategies.add(:password) do
  def valid?
    true
  end

  def authenticate!
    email = params.fetch('user', {})['email']

    if email == "opan@email.com"
      success!(email)
    else
      fail!
    end
  end
end
