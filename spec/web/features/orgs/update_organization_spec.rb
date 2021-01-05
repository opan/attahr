require 'features_helper'

RSpec.describe 'Update organization', type: :feature do
  let(:org_repo) { OrgRepository.new }
  let(:admin_role) { Factory[:org_member_role, name: 'admin'] }
  let(:org) { Factory[:org] }
  let(:profile) { Factory[:profile] }
  let(:user) {
    UserRepository.new.find(profile.user_id)
  }
  let(:org_member) {
    Factory[:org_member, org_member_role_id: admin_role.id, org_id: org.id, profile_id: profile.id]
  }

  context 'with valid user' do
    before(:each) do
      org_member
    end

    it 'able to update an organization' do
      login user: user

      click_link 'Organization'

      expect(page).to have_content org.display_name

      new_display_name = Faker::Name.unique.name

      click_link "#{org.id}-edit-org"
      expect(page).to have_current_path "/orgs/#{org.id}/edit"

      fill_in 'org[display_name]', with: new_display_name
      click_button 'Update'

      expect(page).to have_current_path '/orgs'
      expect(page).to have_content new_display_name
      expect(page).to have_content 'Organization has been successfully updated'
    end
  end

  context 'with invalid user' do
    before(:each) do
      org_member
    end

    it 'not able to update an organization' do
      visit '/orgs'

      expect(page).to have_content %(Don't have account? Create one from here!)
      expect(page).not_to have_current_path '/orgs'
    end

    it 'not able to update organization where user not a member' do
      login

      click_link 'Organization'

      expect(page).not_to have_content org.display_name

      visit "/orgs/#{org.id}/edit"

      expect(page).to have_content 'Organization not found'
      expect(page).to have_current_path '/orgs'
    end
  end
end
