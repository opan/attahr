# frozen_string_literal: true

class PointOfSale < Hanami::Entity
  STATES = { open: 0, closed: 1 }.freeze
end
