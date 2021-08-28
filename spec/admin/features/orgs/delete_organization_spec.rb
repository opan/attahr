require 'features_helper'

RSpec.describe 'Delete an organization', type: :feature do
  let(:org_repo) { OrgRepository.new }
  let(:org_member_repo) { OrgMemberRepository.new }
  let(:superadmin) {
    user = Factory[:superadmin_user]
    ProfileRepository.new.create(name: 'superadmin', user_id: user.id)
    user
  }
  let(:org) { Factory[:org] }

  context 'with superadmin access' do
    before(:each) do
      admin_role = Factory[:org_member_role, name: 'admin']
      @org_member = Factory[:org_member, org_member_role_id: admin_role.id, org_id: org.id]
    end

    it 'can delete any organization' do
      login user: superadmin

      click_link 'Admin Page'
      click_link 'Organizations'

      expect(page).to have_content org.display_name

      click_button "#{org.id}-delete-org"

      expect(page).to have_current_path Admin.routes.orgs_path
      expect(page).to have_content 'Organization has been successfully deleted'

      expect(org_member_repo.find(@org_member.id)).to be_nil
    end
  end
end
