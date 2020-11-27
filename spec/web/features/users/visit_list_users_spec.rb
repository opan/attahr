require 'features_helper'

RSpec.describe 'Visit list users page' do
  let(:repository) { UserRepository.new }

  before(:each) do
    repository.create_with_profile(
      username: 'user-1',
      email: 'user-1@mail.com',
      password_hash: '123',
      profile: {
        name: 'user-1',
      },
    )
  end

  it 'is successfull' do
    login
    visit '/users'

    expect(page).to have_content 'Listing users'
    expect(page).to have_content 'Add User'
    expect(page).to have_content 'user-1@mail.com'
  end
end
