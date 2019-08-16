require 'features_helper'

RSpec.describe 'Visit list users page' do
  let(:repository) { UserRepository.new }

  before(:each) do
    repository.clear
    repository.create(username: 'user-1', email: 'user-1@mail.com')
  end

  it 'is successfull' do
    visit '/users'

    expect(page).to have_content 'Listing users'
    expect(page).to have_content 'Add User'
    expect(page).to have_content 'user-1@mail.com'
  end
end
