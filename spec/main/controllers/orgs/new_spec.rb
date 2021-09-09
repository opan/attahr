RSpec.describe Main::Controllers::Orgs::New, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    before(:each) do
      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq 200
    end

    it 'exposes #org' do
      expect(action.exposures[:org]).to eq Org.new
    end
  end
end
