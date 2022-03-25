# frozen_string_literal: true

RSpec.describe Main::Controllers::PointOfSales::Pos, type: :action do
  let(:pos_repo) { instance_double('PointOfSaleRepository') }
  let(:pos_trx_repo) { instance_double('PosTrxRepository') }
  let(:pos_trx_item_repo) { instance_double('PosTrxItemRepository') }

  let(:user_profile) { @warden.user.profile }
  let(:pos) { Factory.structs[:point_of_sale] }
  let(:open_trx) { Factory.structs[:pos_trx, point_of_sale_id: pos.id] }
  let(:pending_trxes) { Array.new(1) { Factory.structs[:pos_trx, point_of_sale_id: pos.id, state: PosTrx::STATES[:pending]] }}
  let(:open_trx_items) { Array.new(3) { Factory.structs[:pos_trx_item, pos_trx_id: open_trx.id] }}
  let(:new_trx_id) { "#{pos.session_id}/0001" }

  let(:action) { described_class.new(pos_repo: pos_repo, pos_trx_repo: pos_trx_repo, pos_trx_item_repo: pos_trx_item_repo) }
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    context 'when params is valid' do
      before do
        params[:id] = pos.id

        expect(pos_repo).to receive(:find_with_detail).with(pos.id).and_return(pos)
        expect(pos_trx_repo).to receive(:find_pending_by_pos).with(pos.id).and_return(pending_trxes)
        expect(pos_trx_repo).to receive(:find_open_by_pos).with(pos.id).and_return(open_trx)
        expect(pos_trx_item_repo).to receive(:find_by_pos_trx).with(open_trx.id).and_return(open_trx_items)

        @response = action.call(params)
      end

      it 'return 200' do
        expect(@response[0]).to eq(200)
      end

      it 'expose #pos_session' do
        expect(action.exposures[:pos_session].session_id).to eq(pos.session_id)
      end

      it 'expose #open_trx' do
        expect(action.exposures[:open_trx].trx_id).to eq(open_trx.trx_id)
      end

      it 'expose #open_trx_items' do
        expect(action.exposures[:open_trx_items]).to eq(open_trx_items)
      end

      it 'expose #pending_trxes' do
        expect(action.exposures[:pending_trxes]).to eq(pending_trxes)
      end
    end

    context 'when no open transaction' do
      before do
        params[:id] = pos.id
        new_trx = PosTrx.new(trx_id: new_trx_id, pos_id: pos.id, state: PosTrx::STATES[:open])

        expect(pos_repo).to receive(:find_with_detail).with(pos.id).and_return(pos)
        expect(pos_trx_repo).to receive(:find_pending_by_pos).with(pos.id).and_return(pending_trxes)
        expect(pos_trx_repo).to receive(:find_open_by_pos).with(pos.id).and_return(nil)
        expect(pos_trx_repo).to receive(:create).with(new_trx).and_return(new_trx)
        expect(pos_trx_repo).to receive(:get_max_trx_id_by_pos).with(pos.id).and_return(nil)
        expect(pos_trx_item_repo).to receive(:find_by_pos_trx).with(nil).and_return(nil)

        @response = action.call(params)
      end

      it 'return 200' do
        expect(@response[0]).to eq(200)
      end

      it 'create new POS transaction' do
        expect(action.exposures[:open_trx].trx_id).to eq(new_trx_id)
      end
    end

    # context 'when pending transactions available' do
    #   before(:each) do
    #     params[:id] = pos.id

    #     expect(pos_repo).to receive(:find_with_detail).with(pos.id).and_return(pos)
    #     expect(pos_trx_repo).to receive(:find_pending_by_pos).with(pos.id).and_return(pending_trx)
    #     expect(pos_trx_repo).to receive(:find_open_by_pos).with(pos.id).and_return(open_trx)
    #     expect(pos_trx_item_repo).to receive(:find_by_pos_trx).with(open_trx.id).and_return(open_trx)

    #     @response = action.call(params)
    #   end

    #   it 'return 200' do
        
    #   end
    # end
  end
end
