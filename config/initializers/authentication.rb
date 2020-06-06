require 'warden'

Warden::Strategies.add(:password) do
  def valid?
    params['user']['email']
  end

  def authenticate!
    params['user']['email'] == "opan@mail.com" ? success!(params['user']['email']) : fail!('Wrong email')
  end
end
