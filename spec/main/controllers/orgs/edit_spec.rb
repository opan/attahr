RSpec.describe Main::Controllers::Orgs::Edit, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }
  let(:org) { Factory.structs[:org] }
  let(:params) { Hash[id: org.id, 'warden' => @warden] }

  context 'with basic user' do
    before(:each) do
      expect(org_repo).to receive(:find_by_id_and_member).with(org.id, @warden.user.profile.id).and_return org

      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq 200
    end

    it 'exposes #org' do
      expect(action.exposures[:org]).to eq org
    end
  end

  context 'without valid org ID' do
    before(:each) do
      params[:id] = 1000

      expect(org_repo).to receive(:find_by_id_and_member).with(1000, @warden.user.profile.id).and_return nil

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['Cannot find organization with ID [1000]']
    end
  end
end
