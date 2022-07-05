# frozen_string_literal: true

module Main
  module Controllers
    module PointOfSales
      class VoidItem
        include Main::Action
        include Main::Authentication

        accept :json

        before :authenticate!

        def initialize(
          pos_trx_repo: PosTrxRepository.new,
          pos_trx_item_repo: PosTrxItemRepository.new
        )
          @pos_trx_repo = pos_trx_repo
          @pos_trx_item_repo = pos_trx_item_repo
        end

        def call(params)
          unless params.valid?
            self.body = error_messages(params.error_messages)
            self.status = 400
            return
          end

        end
      end
    end
  end
end
