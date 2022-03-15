# frozen_string_literal: true

module Main
  module Controllers
    module PointOfSales
      class Pos
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :pos_session
        expose :pending_trxes
        expose :open_trx
        expose :open_trx_items

        params do
          required(:id).filled(:int?)
        end

        def initialize(
          pos_repo: PointOfSaleRepository.new,
          pos_trx_repo: PosTrxRepository.new,
          pos_trx_item_repo: PosTrxItemRepository.new
        )
          @pos_repo = pos_repo
          @pos_trx_repo = pos_trx_repo
          @pos_trx_item_repo = pos_trx_item_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            redirect_to Main.routes.point_of_sales_path
          end

          @pos_session = @pos_repo.find_with_detail(params[:id])
          if @pos_session.nil?
            flash[:errors] = ["Invalid POS ID: #{params[:id]}"]
            redirect_to Main.routes.point_of_sales_path
          end

          @pending_trxes = @pos_trx_repo.find_pending_by_pos(@pos_session.id)
          @open_trx = @pos_trx_repo.find_open_by_pos(@pos_session.id) || generate_new_trx
          @open_trx_items = @pos_trx_item_repo.find_by_pos_trx(@open_trx.id)
        end

        private

        def generate_new_trx
          session_id = @pos_session.session_id
          trx = @pos_trx_repo.get_max_trx_id_by_pos(@pos_session.id) || "#{session_id}/#{format('%04d', 1)}"
          new_trx_id = trx.nil? ? "#{session_id}/#{format('%04d', 1)}" : trx.trx_id.next
          PosTrx.new(trx_id: new_trx_id)
        end
      end
    end
  end
end
