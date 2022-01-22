RSpec.describe Main::Controllers::Orgs::New, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }

  let(:current_user) { @warden.user }
  let(:root_org) { Factory.structs[:org, is_root: true] }
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    before(:each) do
      expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq 200
    end

    it 'exposes #org' do
      expect(action.exposures[:org]).to eq Org.new
    end

    it 'exposes #parent_id' do
      expect(action.exposures[:parent_id]).to eq root_org.id
    end
  end
end
