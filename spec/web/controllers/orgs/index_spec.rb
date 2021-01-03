RSpec.describe Web::Controllers::Orgs::Index, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }
  let(:user) { User.new(id: 1, profile: Profile.new(id: 1, name: 'foo')) }
  let(:orgs) { [Org.new(id: 1, name: 'org')] }
  let(:params) { Hash['warden' => @warden] }

  context 'with valid user' do
    before(:each) do
      # user.profile.id
      expect(org_repo).to receive(:find_by_member).with(1000).and_return orgs

      @response = action.call(params)
    end

    it 'is return 200' do
      expect(@response[0]).to eq 200
    end

    it 'return list of orgs' do
      expect(action.orgs.to_a).to eq orgs
    end
  end
end
