RSpec.describe Web::Controllers::Orgs::Destroy, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }
  let(:org) { Factory.structs[:org] }
  let(:params) { Hash[id: org.id, 'warden' => WardenDouble] }

  context 'with valid user' do
    before(:each) do
      expect(org_repo).to receive(:find_by_id_and_member).with(org.id, WardenDouble.user.profile.id).and_return org
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

  context 'with invalid user' do
    before(:each) do
      expect(org_repo).to receive(:find_by_id_and_member).with(org.id, WardenDouble.user.profile.id).and_return nil

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
