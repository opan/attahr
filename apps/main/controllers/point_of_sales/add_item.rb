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
          required(:item).schema do
            required(:sku_barcode).filled
            required(:qty).filled(:int?)
          end
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
            self.body = error_message(params.error_messages)
            self.status = 400
            return
          end

          pos = @pos_repo.find(params[:id])
          if pos.nil?
            self.body = error_messages(["Can't find POS record with ID #{params[:id]}"])
            self.status = 400
            return
          end

          product = @product_repo.find_by_sku_or_barcode_and_org(item[:sku_barcode], pos.org_id)
          if product.nil?
            self.body = error_messages(["No product found with SKU or Barcode #{item[:sku_barcode]}"])
            self.status = 400
            return
          end

          pos_trx = @pos_trx_repo.find_by_trx_id(params[:trx_id])
          if pos_trx.nil?
            self.body = error_messages(["Invalid transaction ID #{params[:trx_id]}"])
            self.status = 400
            return
          end

          @pos_repo.transaction do
            create_new_trx_item(pos_trx, product)

            trx_items = @pos_trx_item_repo.find_by_pos_trx(pos_trx.id)
            self.body = JSON.generate(
              {
                trx_items: trx_items.map do |i|
                  {
                    id: i.id,
                    product_id: i.product_id,
                    name: i.name,
                    sku: i.sku,
                    barcode: i.barcode,
                    qty: i.qty,
                    price: i.price
                  }
                end
              })
          end
        end

        private

        def item
          params[:item]
        end

        def create_new_trx_item(pos_trx, product)
          pos_trx_item_entity = PosTrxItem.new(
            pos_trx_id: pos_trx.id,
            product_id: product.id,
            product_category_id: product.product_category_id,
            name: product.name,
            sku: product.sku,
            barcode: product.barcode,
            price: product.price,
            qty: item[:qty],
            created_by_id: current_user.id,
            updated_by_id: current_user.id
          )

          @pos_trx_item_repo.create(pos_trx_item_entity)
        end

        def error_messages(msg = [])
          JSON.generate({ errors: msg })
        end
      end
    end
  end
end
