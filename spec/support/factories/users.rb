Factory.define(:user) do |f|
  f.sequence(:email) { |n| "mail#{n}@mail.com" }
  f.sequence(:username) { |n| "username#{n}" }
  f.password_hash { BCrypt::Password.create('123') }
  f.timestamps
end
