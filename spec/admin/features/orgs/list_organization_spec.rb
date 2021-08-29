require 'features_helper'

RSpec.describe 'List organizations' do
  let(:org_repo) { OrgRepository.new }
  let(:user_repo) { UserRepository.new }
  let(:profile_repo) { ProfileRepository.new }

  let(:superadmin) {
    user = Factory[:superadmin_user]
    profile_repo.create(name: 'superadmin', user_id: user.id)
    user
  }
  let(:org_member) { Factory[:org_member] }

  context 'as a superadmin user' do
    before(:each) do
      org_member
      @orgs = org_repo.all
    end

    it "can see all organizations regardless it's membership status" do
      login user: superadmin

      visit Admin.routes.orgs_path

      @orgs.each do |o|
        expect(page).to have_content o.display_name
      end
    end
  end

  context 'as a basic user' do
    before(:each) do
      org_member
      @user = user_repo.find(profile_repo.find(org_member.profile_id).user_id)
    end

    it "cannot see all organizations on admin pages" do
      login user: @user

      visit Admin.routes.orgs_path
      expect(page).to have_current_path Main.routes.root_path
    end
  end
end
