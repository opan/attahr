RSpec.describe Main::Controllers::Orgs::Index, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }

  let(:orgs) { [Factory.structs[:org, is_root: true]] }
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    before(:each) do
      expect(org_repo).to receive(:all_by_member).with(@warden.user.profile.id).and_return(orgs)

      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq 200
    end

    it 'return list of orgs where they had access' do
      expect(action.orgs.to_a).to eq orgs
    end
  end
end
