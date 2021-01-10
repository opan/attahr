require 'features_helper'

RSpec.describe 'Delete user' do
  let(:user_repo) { UserRepository.new }
  let(:user) {
    profile = Factory[:profile]
    user_repo.find_with_profile(profile.user_id)
  }

  context 'with valid user' do
    before(:each) do
      user
    end

    it 'delete existing user' do
      login

      click_link 'User Management'
      expect(page).to have_content user.email

      click_button "#{user.id}-delete-user"
      expect(page).not_to have_content user.email

      expect(page).to have_current_path Admin.routes.users_path
      expect(page).to have_content I18n.t('users.success.delete')
    end
  end

  context 'with invalid user' do
    it 'cannot delete a user' do
      visit Admin.routes.users_path

      expect(page).not_to have_content 'User Management'
      expect(page).not_to have_current_path Admin.routes.users_path
    end
  end
end
