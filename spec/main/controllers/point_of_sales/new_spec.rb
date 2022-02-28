# frozen_string_literal: true

RSpec.describe Main::Controllers::PointOfSales::New, type: :action do
  let(:pos_repo) { instance_double('PointOfSaleRepository') }
  let(:org_repo) { instance_double('OrgRepository') }

  let(:action) { described_class.new(pos_repo: pos_repo, org_repo: org_repo) }
  let(:params) { Hash['warden' => @warden] }
  let(:current_user) { @warden.user }
  let(:root_org) { Factory[:org, is_root: true] }
  let(:pos) { Factory.structs[:point_of_sale] }

  context 'with basic user' do
    context 'when no open pos session' do
      before do
        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(pos_repo).to receive(:find_open_pos_by_user).with(current_user.profile.id).and_return nil

        @response = action.call(params)
      end

      it 'return 200' do
        expect(@response[0]).to eq(200)
      end

      it 'expose #pos_session' do
        expect(action.exposures[:pos_session].session_id).not_to be_nil
      end

      it 'expose #root_org' do
        expect(action.exposures[:root_org]).to eq(root_org)
      end
    end

    context 'when there is opened pos session' do
      before do
        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(pos_repo).to receive(:find_open_pos_by_user).with(current_user.profile.id).and_return pos

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq(302)
      end

      it 'got error messages' do
        expect(action.exposures[:flash][:errors]).to eq(['There is still active POS session created by you.
              Please close it first before create a new session'])
      end
    end

    context 'when no root org found' do
      before do
        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(nil)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq(302)
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ["Can't find root organization for current user"]
      end
    end
  end
end
