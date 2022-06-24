# frozen_string_literal: true

RSpec.describe Main::Controllers::PointOfSales::AddItem, type: :action do
  let(:pos_repo) { instance_double('PointOfSaleRepository') }
  let(:pos_trx_repo) { instance_double('PosTrxRepository') }
  let(:pos_trx_item_repo) { instance_double('PosTrxItemRepository') }
  let(:product_repo) { instance_double('ProductRepository') }

  let(:current_user) { @warden.user }
  let(:product) { Factory.structs[:product] }
  let(:pos_session) { Factory.structs[:point_of_sale] }
  let(:pos_trx) { Factory.structs[:pos_trx, point_of_sale_id: pos_session.id] }
  let(:action) {
    described_class.new(
      pos_repo: pos_repo,
      pos_trx_repo: pos_trx_repo,
      pos_trx_item_repo: pos_trx_item_repo,
      product_repo: product_repo
    )
  }
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    context 'when all params are valid' do
      before do
        params.merge!({ id: pos_session.id, trx_id: pos_trx.id, item: { sku_barcode: product.sku, qty: 1 }})
        pos_trx_item_entity = PosTrxItem.new(
          pos_trx_id: pos_trx.id,
          product_id: product.id,
          name: product.name,
          sku: product.sku,
          barcode: product.barcode,
          price: product.price,
          qty: 1,
          created_by_id: current_user.id,
          updated_by_id: current_user.id
        )

        expect(pos_repo).to receive(:find).with(pos_session.id).and_return pos_session
        expect(product_repo).to receive(:find_by_sku_or_barcode_and_org).with(product.sku, pos_session.org_id).and_return(product)
        expect(pos_trx_repo).to receive(:find_by_trx_id).with(pos_trx.id).and_return(pos_trx)
        expect(pos_repo).to receive(:transaction).and_yield
        expect(pos_trx_item_repo).to receive(:create).with(pos_trx_item_entity)
        expect(pos_trx_item_repo).to receive(:find_by_pos_trx).with(pos_trx.id).and_return([pos_trx_item_entity])

        @response = action.call(params)
      end

      it 'return 200' do
        expect(@response[0]).to eq(200)
      end

      it 'return #trx_items' do
        expect(JSON.parse(@response[2][0]).length).to eq 1
      end
    end

    context 'when params ID invalid' do
      before do
        params.merge!({ id: 123, trx_id: 1, item: { sku_barcode: product.sku, qty: 1 } })

        expect(pos_repo).to receive(:find).with(123).and_return nil

        @response = action.call(params)
      end

      it 'return 400' do
        expect(@response[0]).to eq(400)
      end

      it 'return #errors' do
        expect(JSON.parse(@response[2][0])['errors']).to eq(["Can't find POS record with ID 123"])
      end
    end

    context 'when params trx_id invalid' do
      before do
        params.merge!({ id: pos_session.id, trx_id: 234, item: { sku_barcode: product.sku, qty: 1 }})

        expect(pos_repo).to receive(:find).with(pos_session.id).and_return pos_session
        expect(product_repo).to receive(:find_by_sku_or_barcode_and_org).with(product.sku, pos_session.org_id).and_return(product)
        expect(pos_trx_repo).to receive(:find_by_trx_id).with(234).and_return nil

        @response = action.call(params)
      end

      it 'return 400' do
        expect(@response[0]).to eq(400)
      end

      it 'return #errors' do
        expect(JSON.parse(@response[2][0])['errors']).to eq(['Invalid transaction ID 234'])
      end
    end
  end
end
