RSpec.describe Admin::Controllers::Orgs::Index, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }

  let(:warden) { WardenMock.new(true, true, true, Factory.structs[:superadmin_user]) }
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
