RSpec.describe Web::Controllers::Orgs::Edit, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }
  let(:org) { Factory.structs[:org] }
  let(:params) { Hash[id: org.id, 'warden' => @warden] }

  context 'when org exists' do
    before(:each) do
      expect(org_repo).to receive(:find_through_member).with(org.id).and_return org

      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response).to have_http_status 200
    end

    it 'expose #org' do
      expect(action.exposures[:org].display_name).to eq org.display_name
    end
  end

  context 'when org does not exists' do
    before(:each) do
      expect(org_repo).to receive(:find_through_member).with(10000).and_return nil
      params[:id] = 10000

      @response = action.call(params)
    end

    it 'return 404' do
      expect(@response).to have_http_status 404
    end

    it 'expose errors message' do
      expect(action.exposures[:flash][:errors]).to eq ['Organization not found']
    end
  end
end
