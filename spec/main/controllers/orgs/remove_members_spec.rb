RSpec.describe Main::Controllers::Orgs::RemoveMembers, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }
  let(:action) { described_class.new(org_repo: org_repo, org_member_repo: org_member_repo) }

  let(:org) { Factory.structs[:org] }
  let(:params) { Hash['warden' => @warden] }
  let(:user_profile) { @warden.user.profile }

  context 'with basic user with admin role' do
    before(:each) do
      params[:id] = org.id
      params[:member_id] = 1000
      expect(org_member_repo).to receive(:is_admin?).with(org.id, user_profile.id).and_return(true)
      expect(org_repo).to receive(:find).with(org.id).and_return(org)
      expect(org_member_repo).to receive(:delete_by_org_and_user).with(org.id, 1000)

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got success messages' do
      expect(action.exposures[:flash][:info]).to eq ["User has been successfully removed from organization [#{org.display_name}]"]
    end
  end

  context 'without member ID' do
    before(:each) do
      params[:id] = org.id

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['Member Id is missing']
    end
  end

  context 'with basic user without admin role' do
    before(:each) do
      params[:id] = org.id
      params[:member_id] = 1000
      expect(org_member_repo).to receive(:is_admin?).with(org.id, user_profile.id).and_return(false)

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['You are not allowed to perform this action']
    end
  end

  context 'without valid org ID' do
    before(:each) do
      params[:id] = org.id
      params[:member_id] = 1000
      expect(org_member_repo).to receive(:is_admin?).with(org.id, user_profile.id).and_return(true)
      expect(org_repo).to receive(:find).with(org.id).and_return(nil)

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ["Cannot find organization with ID [#{org.id}]"]
    end
  end
end
