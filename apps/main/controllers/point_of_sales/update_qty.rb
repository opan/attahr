# frozen_string_literal: true

module Main
  module Controllers
    module PointOfSales
      class UpdateQty
        include Main::Action
        include Main::Authentication

        accept :json

        before :authenticate!

        params do
          required(:trx_id).filled
          required(:trx_item_id).filled
          required(:updated_qty).filled(:int?)
        end

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

          pos_trx = @pos_trx_repo.find_by_trx_id(params[:trx_id])
          if pos_trx.nil?
            self.body = error_messages(["Invalid transaction ID #{params[:trx_id]}"])
            self.status = 400
            return
          end

          @pos_trx_repo.transaction do
            pos_trx_item = @pos_trx_item_repo.find(params[:trx_item_id])
            if pos_trx_item.nil? || pos_trx_item.pos_trx_id != pos_trx.id
              self.body = error_messages(["Invalid transaction item #{params[:trx_item_id]}"])
              self.status = 400
              return
            end

            trx_item_entity = PosTrxItem.new(pos_trx_item.to_h.merge!({ qty: params[:updated_qty] }))
            @pos_trx_item_repo.update(pos_trx_item.id, trx_item_entity)

            trx_items = @pos_trx_item_repo.find_by_pos_trx(pos_trx.id)
            self.body = JSON.generate(
              {
                trx_items: trx_items.map { |i| PosTrxItemList.new(i).to_h }
              }
            )
          end
        end

        private

        def error_messages(msg = [])
          JSON.generate({ errors: msg })
        end

        def verify_csrf_token?
          false
        end
      end
    end
  end
end
