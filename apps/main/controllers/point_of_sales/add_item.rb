# frozen_string_literal: true

module Main
  module Controllers
    module PointOfSales
      class AddItem
        include Main::Action
        include Main::Authentication

        accept :json

        before :authenticate!

        params do
          required(:id).filled(:int?)
          required(:trx_id).filled
          required(:sku_barcode).filled
        end

        def initialize(
          pos_repo: PointOfSaleRepository.new,
          pos_trx_repo: PosTrxRepository.new,
          pos_trx_item_repo: PosTrxItemRepository.new,
          product_repo: ProductRepository.new
        )
          @pos_repo = pos_repo
          @pos_trx_repo = pos_trx_repo
          @pos_trx_item_repo = pos_trx_item_repo
          @product_repo = product_repo
        end

        def call(params)
          unless params.valid?
            self.body = errors_message(params.error_messages)
            self.status = 400
            return
          end

          pos = @pos_repo.find(params[:id])
          if pos.nil?
            self.body = error_messages(["Can't find POS record with ID #{params[:id]}"])
            self.status = 400
            return
          end

          product = @product_repo.find_by_sku_or_barcode_and_org(params[:sku_barcode], pos.org_id)
          if product.nil?
            self.body = error_messages(["No product found with SKU or Barcode #{params[:sku_barcode]}"])
            self.status = 400
            return
          end

          pos_trx = @pos_trx_repo.find(params[:trx_id])
          if pos_trx.nil?
            self.body = error_messages(["Invalid transaction ID #{params[:trx_id]}"])
            self.status = 400
            return
          end


        end

        private

        def create_new_trx_item(trx_id, product)
          pos_trx_item = PosTrxItem.new(
            pos_trx_id: trx_id,
            product_id: product.id,
            name: product.name,
            sku: product.sku,
            barcode: product.barcode,
            price: product.price
          )
        end

        def error_messages(msg = [])
          raw JSON.generate({ errors: msg })
        end
      end
    end
  end
end
