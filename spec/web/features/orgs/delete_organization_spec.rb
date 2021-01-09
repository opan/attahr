require 'features_helper'

RSpec.describe 'Delete an organizatio', type: :feature do
  let(:org_repo) { OrgRepository.new }
  let(:org_member_repo) { OrgMemberRepository.new }
  let(:profile) { Factory[:profile] }
  let(:admin_role) { Factory[:org_member_role, name: 'admin'] }
  let(:org_member) { Factory[:org_member, profile_id: profile.id, org_member_role_id: admin_role.id] }
  let(:user) {
    UserRepository.new.find(profile.user_id)
  }
  let(:org) { org_repo.find(org_member.org_id) }

  context 'with valid user' do
    before(:each) do
      org
    end

    it 'can delete an organization' do
      login user: user

      click_link 'Organizations'

      expect(page).to have_content org.display_name

      click_button "#{org.id}-delete-org"

      expect(page).to have_current_path "/orgs"
      expect(page).to have_content 'Organization has been successfully deleted'

      expect(org_member_repo.find(org_member.id)).to be_nil
    end
  end
end
