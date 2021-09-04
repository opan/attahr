RSpec.describe Admin::Controllers::Orgs::Destroy, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }

  let(:warden) { WardenMock.new(true, true, true, Factory.structs[:superadmin_user]) }
  let(:profile) { Factory.structs[:profile, user_id: warden.user.id] }
  let(:org) { Factory.structs[:org] }
  let(:params) { Hash[id: org.id, 'warden' => warden] }

  context 'with superadmin user' do
    context 'with valid ID' do
      before(:each) do
        expect(org_repo).to receive(:find).with(org.id).and_return(org)
        expect(org_repo).to receive(:delete).with(org.id)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response).to have_http_status 302
      end

      it 'got a success messages' do
        expect(action.exposures[:flash][:info]).to eq ['Organization has been successfully deleted']
      end
    end

    context 'with invalid ID' do
      before(:each) do
        expect(org_repo).to receive(:find).with(org.id).and_return(nil)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response).to have_http_status 302
      end

      it 'got an errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ['Organization not found']
      end
    end
  end

  context 'with basic user' do
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
