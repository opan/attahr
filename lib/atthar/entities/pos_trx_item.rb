# frozen_string_literal: true

class PosTrxItem < Hanami::Entity
  STATES = { open: 0, void: 1 }.freeze
end
