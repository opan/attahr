RSpec.describe Web::Controllers::Orgs::Index, type: :action do
  let(:user_repo) { instance_double('UserRepository') }
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo, user_repo: user_repo) }
  let(:user) { User.new(id: 1, profile: Profile.new(id: 1, name: 'foo')) }
  let(:orgs) { [Org.new(id: 1, name: 'org')] }
  let(:params) { Hash[user_id: 1, 'warden' => @warden] }

  context 'with valid user_id' do
    before(:each) do
      expect(user_repo).to receive(:find_with_profile).with(params[:user_id]).and_return user
      expect(org_repo).to receive(:find_by_member).with(user.profile.id).and_return orgs

      @response = action.call(params)
    end

    it 'is return 200' do
      expect(@response[0]).to eq 200
    end

    it 'return list of orgs' do
      expect(action.orgs.to_a).to eq orgs
    end
  end

  context 'with invalid user_id' do
    before(:each) do
      expect(user_repo).to receive(:find_with_profile).with(params[:user_id]).and_return nil

      @response = action.call(params)
    end

    it 'return 404' do
      expect(@response[0]).to eq 404
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq 'User not found'
    end
  end
end
