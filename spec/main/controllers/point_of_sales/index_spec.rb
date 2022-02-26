# frozen_string_literal: true

RSpec.describe Main::Controllers::PointOfSales::Index, type: :action do
  let(:pos_repo) { instance_double('PointOfSaleRepository') }
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(pos_repo: pos_repo, org_repo: org_repo) }
  let(:params) { Hash['warden' => @warden] }

  let(:current_user) { @warden.user }
  let(:pos_sessions) { Array.new(2) { Factory.structs[:point_of_sale] } }
  let(:root_org) { Factory[:org, is_root: true] }

  context 'with basic user' do
    before(:each) do
      expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return root_org
      expect(pos_repo).to receive(:all_by_org).with(root_org.id).and_return(pos_sessions)

      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq 200
    end

    it 'return list of pos sessions' do
      expect(action.exposures[:pos_sessions]).to eq(pos_sessions)
    end
  end
end
