require 'features_helper'

RSpec.describe 'Add new user' do
  let(:repository) { UserRepository.new }

  context 'when data valid' do
    it 'create new user' do
      visit '/users'

      click_link 'Add User'
      fill_in 'Username', with: 'new-user'
      fill_in 'Email', with: 'new-user@mail.com'
      click_button 'Create'

      expect(page).to have_content %(new-user)
      expect(page).to have_content %(new-user\@mail\.com)
    end
  end

  context 'when data invalid' do
    it 'show error messages' do
      visit '/users'

      click_link 'Add User'
      fill_in 'Username', with: 'new-user'
      fill_in 'Email', with: 'new-user#mail.com'
      click_button 'Create'

      expect(page).to have_content %(Email is in invalid format)
    end
  end
end
