require 'features_helper'

RSpec.describe 'Create a new organization', type: :feature do
  let(:org_repo) { OrgRepository.new }
  let(:profile_repo) { ProfileRepository.new }

  let(:admin_role) { Factory[:org_member_role_admin] }
  let(:superadmin) {
    user = Factory[:superadmin_user]
    profile_repo.create(name: 'superadmin', user_id: user.id)
    user
  }

  context 'as a superadmin user' do
    before(:each) { admin_role }

    context 'with valid parameters' do
      it 'can create new organization from admin page' do
        login user: superadmin

        click_link 'Admin Page'
        click_link 'Organizations'

        expect(page).to have_content %(New organization)

        click_link 'New organization'

        fill_in name: 'org[name]', with: 'pt. new world order, tbk'
        fill_in name: 'org[display_name]', with: 'PT New World Order'
        fill_in name: 'org[address]', with: Faker::Address.street_address
        fill_in name: 'org[phone_numbers]', with: Faker::PhoneNumber.cell_phone
        click_button 'Create'

        expect(page).to have_current_path Admin.routes.orgs_path
        expect(page).to have_content 'pt. new world order, tbk'
      end
    end

    context 'with invalid parameters' do
      it 'failed to create a new organization' do
        login user: superadmin

        click_link 'Admin Page'
        click_link 'Organizations'

        expect(page).to have_content %(New organization)

        click_link 'New organization'

        fill_in name: 'org[display_name]', with: 'PT New World Order'
        fill_in name: 'org[address]', with: Faker::Address.street_address
        fill_in name: 'org[phone_numbers]', with: Faker::PhoneNumber.cell_phone
        click_button 'Create'

        expect(page).to have_current_path Admin.routes.orgs_path
        expect(page).to have_content 'Name must be filled'
      end
    end
  end

  context 'as a basic user' do
    it 'cannot access organization page on admin page' do
      visit Admin.routes.orgs_path

      expect(page).not_to have_current_path Admin.routes.orgs_path
      expect(page).to have_content %(Don't have account? Create one from here!)
    end
  end
end
