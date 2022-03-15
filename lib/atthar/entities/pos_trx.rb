# frozen_string_literal: true

class PosTrx < Hanami::Entity
  STATES = {
    open: 0,
    closed: 1,
    void: 2,
    pending: 3
  }
end
