# frozen_string_literal: true

RSpec.describe Main::Controllers::PointOfSales::UpdateQty, type: :action do
  let(:pos_trx_repo) { instance_double('PosTrxRepository') }
  let(:pos_trx_item_repo) { instance_double('PosTrxItemRepository') }

  let(:current_user) { @warden.user }
  let(:pos_trx) { Factory.structs[:pos_trx] }
  let(:pos_trx_item) { Factory.structs[:pos_trx_item, pos_trx_id: pos_trx.id] }
  let(:action) {
    described_class.new(
      pos_trx_repo: pos_trx_repo,
      pos_trx_item_repo: pos_trx_item_repo
    )
  }
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    context 'when all params are valid' do
      before do
        params.merge!({ trx_id: pos_trx.id, trx_item_id: pos_trx_item.id, updated_qty: 5 })
        # updated_trx_item = PosTrxItem.new(pos_trx_item.to_h.merge!({ qty: 5 }))

        expect(pos_trx_repo).to receive(:find_by_trx_id).with(pos_trx.id).and_return(pos_trx)
        expect(pos_trx_repo).to receive(:transaction).and_yield
        expect(pos_trx_item_repo).to receive(:find).with(pos_trx_item.id).and_return(pos_trx_item)
        expect(pos_trx_item_repo).to receive(:update).with(pos_trx_item.id, { qty: 5 })
        expect(pos_trx_item_repo).to receive(:find_by_pos_trx).with(pos_trx.id).and_return([pos_trx_item])

        @response = action.call(params)
      end

      it 'return 200' do
        expect(@response[0]).to eq(200)
      end

      it 'return #trx_items' do
        expect(JSON.parse(@response[2][0]).length).to eq 1
      end
    end

    context 'when trx_id is invalid' do
      before do
        params.merge!({ trx_id: pos_trx.id, trx_item_id: pos_trx_item.id, updated_qty: 5 })

        expect(pos_trx_repo).to receive(:find_by_trx_id).with(pos_trx.id).and_return(nil)

        @response = action.call(params)
      end

      it 'return 400' do
        expect(@response[0]).to eq(400)
      end

      it 'return #errors' do
        expect(JSON.parse(@response[2][0])['errors']).to eq(["Invalid transaction ID #{pos_trx.id}"])
      end
    end

    context 'when trx_item_id is invalid' do
      before do
        params.merge!({ trx_id: pos_trx.id, trx_item_id: pos_trx_item.id, updated_qty: 5 })

        expect(pos_trx_repo).to receive(:find_by_trx_id).with(pos_trx.id).and_return(pos_trx)
        expect(pos_trx_repo).to receive(:transaction).and_yield
        expect(pos_trx_item_repo).to receive(:find).with(pos_trx_item.id).and_return(nil)

        @response = action.call(params)
      end

      it 'return 400' do
        expect(@response[0]).to eq(400)
      end

      it 'return #errors' do
        expect(JSON.parse(@response[2][0])['errors']).to eq(["Invalid transaction item #{pos_trx_item.id}"])
      end
    end
  end
end
