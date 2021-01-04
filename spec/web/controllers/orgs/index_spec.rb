RSpec.describe Web::Controllers::Orgs::Index, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }
  let(:profile) { Factory.structs[:profile] }
  let(:user) { User.new(Factory.structs[:user, id: profile.user_id].to_h.merge(profile: profile.to_h)) }
  let(:orgs) { [Org.new(id: 1, name: 'org')] }
  let(:params) { Hash['warden' => @warden] }

  context 'with valid user' do
    before(:each) do
      # 1000 is user.profile.id
      expect(org_repo).to receive(:find_by_member).with(1000).and_return orgs

      @response = action.call(params)
    end

    it 'is return 200' do
      expect(@response).to have_http_status(200)
    end

    it 'return list of orgs' do
      expect(action.orgs.to_a).to eq orgs
    end
  end
end
