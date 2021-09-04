RSpec.describe Admin::Controllers::Orgs::Index, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }

  let(:warden) { WardenMock.new(true, true, true, Factory.structs[:superadmin_user]) }
  # let(:profile) { Factory.structs[:profile] }
  # let(:user) { User.new(Factory.structs[:user, id: profile.user_id].to_h.merge(profile: profile.to_h)) }
  let(:orgs) { [Factory.structs[:org]] }
  let(:params) { Hash['warden' => warden] }

  context 'with superadmin user' do
    before(:each) do
      expect(org_repo).to receive(:all).and_return orgs

      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response).to have_http_status(200)
    end

    it 'return list of orgs' do
      expect(action.orgs.to_a).to eq orgs
    end
  end

  context 'with basic user' do
    context 'with valid params' do
      before(:each) do
        params['warden'] = @warden

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response).to have_http_status 302
      end

      it 'got an errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ["You're not allowed to access this page"]
      end
    end
  end
end
