RSpec.describe Main::Controllers::Orgs::Update, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }

  let(:org) { Factory.structs[:org] }
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    before(:each) do
      updated_org = Org.new(org.to_h.merge!({ address: 'This is the real neighbourhood' }))
      params.merge!({
        id: org.id,
        org: updated_org.to_h
      })

      expect(org_repo).to receive(:find_by_id_and_member).with(org.id, @warden.user.profile.id).and_return org
      expect(org_repo).to receive(:update).with(org.id, updated_org)

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got a success messages' do
      expect(action.exposures[:flash][:info]).to eq ['Organization has been successfully updated']
    end
  end

  context 'with invalid params' do
    before(:each) do
      updated_org = Org.new(org.to_h.merge!({ address: 'This is the real neighbourhood' }))
      params.merge!({
        id: org.id,
        org: updated_org.to_h.reject!{ |k, v| [:name].include? k }
      })

      @response = action.call(params)
    end

    it 'return 422' do
      expect(@response[0]).to eq 422
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['Name is missing']
    end
  end
end
