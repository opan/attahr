require 'features_helper'

RSpec.describe 'List organizations' do
  let(:org_repo) { OrgRepository.new }
  let(:user_repo) { UserRepository.new }
  let(:user) {
    profile = Factory[:profile]
    user_repo.find_with_profile(profile.user_id)
  }

  before(:each) do
    staff_role = Factory[:org_member_role]
    member = Factory[:org_member, org_member_role_id: staff_role.id, profile_id: user.profile.id]
    @org = org_repo.find(member.org_id)
  end

  it 'list organizations available for current user' do
    login user: user, password_supply: '123'

    visit '/orgs'

    expect(page).to have_content 'New organization'
    expect(page).to have_content @org.display_name
  end
end
