class Orgs < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :name, Types::String
    attribute :address, Types::String
    attribute :phone_numbers, Types::String
    attribute :created_at, Types::DateTime
    attribute :updated_at, Types::DateTime
    attribute :created_by_id, Types::Int
    attribute :updated_by_id, Types::Int
  end
end
