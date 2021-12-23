RSpec.describe Main::Controllers::Orgs::InviteMembers, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }
  let(:org_invitation_repo) { instance_double('OrgInvitationRepository') }
  let(:action) { described_class.new(org_repo: org_repo, org_member_repo: org_member_repo, org_invitation_repo: org_invitation_repo) }

  let(:org) { Factory.structs[:org] }
  let(:invitee_email) { 'foo1@mail.com' }
  let(:params) { Hash['warden' => @warden] }
  let(:user_profile) { @warden.user.profile }

  context 'with basic user with admin role' do
    before(:each) do
      params[:id] = org.id
      params[:invite_members] = {
        users_email: invitee_email
      }

      expect(org_member_repo).to receive(:admin?).with(org.id, user_profile.id).and_return(true)
      expect(org_repo).to receive(:find).with(org.id).and_return(org)
      expect(org_member_repo).to receive(:find_by_emails).with(invitee_email).and_return([])
      expect(org_member_repo).to receive(:find_by_emails).with(@warden.user.email).and_return([])

      timeout = OrgInvitation::TIMEOUT
      invite_data = OrgInvitation.new(
        org_id: org.id,
        invite_id: SecureRandom.uuid,
        invitees: invitee_email,
        inviter: @warden.user.email,
        timeout: Time.now + timeout
      )
      expect(org_invitation_repo).to receive(:create).with(any_args).and_return(invite_data)

      Hanami::Mailer.deliveries.clear

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'send an emails' do
      mail = Hanami::Mailer.deliveries.last
      expect(mail.to).to eq [invitee_email]
    end
  end
end
