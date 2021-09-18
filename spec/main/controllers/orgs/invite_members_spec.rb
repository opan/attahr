RSpec.describe Main::Controllers::Orgs::InviteMembers, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }
  let(:action) { described_class.new(org_repo: org_repo, org_member_repo: org_member_repo) }

  let(:org) { Factory.structs[:org] }
  let(:params) { Hash['warden' => @warden] }
  let(:user_profile) { @warden.user.profile }

  context 'with basic user with admin role' do
    before(:each) do
      params[:id] = org.id
      params[:invite_members] = {
        users_email: ["foo1@mail.com"]
      }

      expect(org_member_repo).to receive(:is_admin?).with(org.id, user_profile.id).and_return(true)
      expect(org_repo).to receive(:find).with(org.id).and_return(org)
      expect(org_member_repo).to receive(:find_by_emails).with(params[:invite_members][:users_email]).and_return([])
      expect(org_member_repo).to receive(:find_by_emails).with(@warden.user.email).and_return([])

      Hanami::Mailer.deliveries.clear

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end
  end
end
