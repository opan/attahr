# frozen_string_literal: true

RSpec.describe Main::Controllers::PointOfSales::Create, type: :action do
  let(:pos_repo) { instance_double('PointOfSaleRepository') }
  let(:org_repo) { instance_double('OrgRepository') }

  let(:action) { described_class.new(pos_repo: pos_repo, org_repo: org_repo) }
  let(:params) { Hash['warden' => @warden] }
  let(:root_org) { Factory[:org, is_root: true] }
  let(:current_user) { @warden.user }

  context 'with basic user' do
    context 'when all params valid' do
      before do
        params[:point_of_sale] = {
          session_id: 'random-id',
          cashier_id: current_user.profile.id,
          password: 'foo-bar',
          org_id: root_org.id
        }
        pos_entity = PointOfSale.new(params[:point_of_sale].merge(
          {
            state: PointOfSale::STATES[:open],
            created_by_id: current_user.profile.id,
            updated_by_id: current_user.profile.id
          })
        )

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        allow(pos_repo).to receive(:transaction).and_yield
        expect(pos_repo).to receive(:create).with(pos_entity)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq(302)
      end

      it 'got success messages' do
        expect(action.exposures[:flash][:info]).to eq(['POS session has been successfully created'])
      end
    end

    context 'when root org not found' do
      before do
        params[:point_of_sale] = {
          session_id: 'random-id',
          cashier_id: current_user.profile.id,
          password: 'foo-bar',
          org_id: 101
        }

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return nil

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq(302)
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq(["Can't find root organization for current user"])
      end
    end

    context 'when params invalid' do
      before do
        params[:point_of_sale] = {
          session_id: 'random-id',
          password: 'foo-bar',
          org_id: root_org.id
        }

        @response = action.call(params)
      end

      it 'return 422' do
        expect(@response[0]).to eq(422)
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq(['Cashier Id is missing'])
      end
    end

    context 'when password not match' do
      before do
        params[:point_of_sale] = {
          session_id: 'random-id',
          cashier_id: current_user.profile.id,
          password: 'foo-bar-wrong',
          org_id: root_org.id
        }

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)

        @response = action.call(params)
      end

      it 'return 422' do
        expect(@response[0]).to eq(422)
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq(['Invalid password'])
      end

      it 'expose #pos_session' do
        expect(action.exposures[:pos_session].session_id).to eq('random-id')
      end

      it 'expose #root_org' do
        expect(action.exposures[:root_org]).to eq(root_org)
      end
    end
  end
end
