# frozen_string_literal: true

RSpec.describe Main::Controllers::PointOfSales::Show, type: :action do
  let(:pos_repo) { instance_double('PointOfSaleRepository') }
  let(:pos_trx_repo) { instance_double('PosTrxRepository') }

  let(:action) { described_class.new(pos_repo: pos_repo, pos_trx_repo: pos_trx_repo) }
  let(:user_profile) { @warden.user.profile }
  let(:pos) { Factory.structs[:point_of_sale] }
  let(:pos_trxes) { Array.new(2) { Factory.structs[:pos_trx, point_of_sale_id: pos.id] }}
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    context 'when all params valid' do
      before do
        params[:id] = pos.id

        expect(pos_repo).to receive(:find_with_detail).with(pos.id).and_return pos
        expect(pos_trx_repo).to receive(:all_by_pos).with(pos.id).and_return pos_trxes

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq(200)
      end

      it 'expose #pos_session' do
        expect(action.exposures[:pos_session].id).to eq(pos.id)
      end

      it 'expose #pos_trxes' do
        expect(action.exposures[:pos_trxes].length).to eq(2)
      end
    end
  end
end
