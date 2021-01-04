RSpec.describe Web::Controllers::Orgs::Update, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:org) { Factory.structs[:org] }
  let(:action) { described_class.new(org_repo: org_repo) }
  let(:params) { Hash[id: org.id, 'warden' => @warden] }
  let(:org_update) { Factory.structs[:org].to_h.reject { |k,v| [:id, :created_at, :updated_at].include?(k) } }

  context 'with valid params' do
    before(:each) do
      params[:org] = org_update

      expect(org_repo).to receive(:find).with(org.id).and_return org
      expect(org_repo).to receive(:update).with(org.id, Org.new(org_update)).and_return org

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response).to have_http_status 302
    end

    it 'got a success messages' do
      expect(action.exposures[:flash][:info]).to eq ['Organization has been successfully updated']
    end

    it 'redirects to /orgs' do
      expect(@response).to redirect_to '/orgs'
    end
  end

  context 'with invalid params' do
    before(:each) do
      params[:org] = org_update.reject { |k,v| k == :name }

      @response = action.call(params)
    end

    it 'return 422' do
      expect(@response).to have_http_status 422
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['Name is missing']
    end
  end

  context 'with invalid ID' do
    before(:each) do
      params[:org] = org_update

      expect(org_repo).to receive(:find).with(org.id).and_return nil

      @response = action.call(params)
    end

    it 'return 404' do
      expect(@response).to have_http_status 404
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['Organization not found']
    end
  end
end
