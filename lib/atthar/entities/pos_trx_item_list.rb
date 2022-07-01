# frozen_string_literal: true

class PosTrxItemList < Hanami::Entity
  attributes do
    attribute :id,          Types::Int
    attribute :product_id,  Types::Int
    attribute :name,        Types::String
    attribute :sku,         Types::String
    attribute :barcode,     Types::String
    attribute :qty,         Types::Int
    attribute :price,       Types::Coercible::Int
  end
end
