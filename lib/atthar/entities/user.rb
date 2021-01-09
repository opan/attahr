class User < Hanami::Entity
  EMAIL_FORMAT = URI::MailTo::EMAIL_REGEXP

  attributes do
    attribute :id, Types::Int
    attribute :username, Types::String
    attribute :email, Types::String.constrained(format: EMAIL_FORMAT)
    attribute :password_hash, Types::String
    attribute :superadmin, Types::Bool
    attribute :created_at, Types::DateTime
    attribute :updated_at, Types::DateTime

    attribute :profile, Types::Entity(Profile)
  end
end
