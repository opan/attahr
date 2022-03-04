# frozen_string_literal: true

module Main
  module Controllers
    module PointOfSales
      class Show
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :pos_session
        expose :pos_trxes

        params do
          required(:id).filled(:int?)
        end

        def initialize(pos_repo: PointOfSaleRepository.new, pos_trx_repo: PosTrxRepository.new)
          @pos_repo = pos_repo
          @pos_trx_repo = pos_trx_repo
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

          @pos_trxes = @pos_trx_repo.all_by_pos(@pos_session.id)
        end
      end
    end
  end
end
