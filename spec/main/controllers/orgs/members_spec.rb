RSpec.describe Main::Controllers::Orgs::Members, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }
  let(:action) { described_class.new(org_repo: org_repo, org_member_repo: org_member_repo) }

  let(:org) { Factory.structs[:org] }
  let(:org_members) { Array.new(2) { Factory.structs[:org_member, org_id: org.id] } }
  let(:params) { Hash['warden' => @warden] }
  let(:user_profile) { @warden.user.profile }

  context 'with basic user with admin role' do
    before(:each) do
      params[:id] = org.id
      expect(org_member_repo).to receive(:admin?).with(org.id, user_profile.id).and_return(true)
      expect(org_repo).to receive(:find).with(org.id).and_return(org)
      expect(org_member_repo).to receive(:find_by_org).with(org.id).and_return(org_members)

      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq 200
    end

    it 'expose #org'  do
      expect(action.exposures[:org]).to eq org
    end

    it 'expose #org_members'  do
      expect(action.exposures[:org_members]).to eq org_members
    end
  end

  context 'with basic user without admin role' do
    before(:each) do
      params[:id] = org.id
      expect(org_member_repo).to receive(:admin?).with(org.id, user_profile.id).and_return(false)

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got errors messages'  do
      expect(action.exposures[:flash][:errors]).to eq ['You are not allowed to perform this action']
    end
  end

  context 'without ID' do
    before(:each) do
      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got errors messages'  do
      expect(action.exposures[:flash][:errors]).to eq ['Id is missing']
    end
  end

  context 'without valid org ID' do
    before(:each) do
      params[:id] = org.id
      expect(org_member_repo).to receive(:admin?).with(org.id, user_profile.id).and_return(true)
      expect(org_repo).to receive(:find).with(org.id).and_return(nil)

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got errors messages'  do
      expect(action.exposures[:flash][:errors]).to eq ["Cannot find organization with ID [#{org.id}]"]
    end
  end
end
