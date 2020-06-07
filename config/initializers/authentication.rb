require 'warden'

Warden::Strategies.add(:password) do
  def authenticate!
    pry
    params.fetch('user', {})['email'] == "opan@mail.com" ? success!(params['user']['email']) : fail!('Wrong email')
  end
end
