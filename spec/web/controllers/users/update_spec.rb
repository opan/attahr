RSpec.describe Web::Controllers::Users::Update, type: :action do
  let(:user_repo) { instance_double('UserRepository') }
  let(:profile_repo) { instance_double('ProfileRepository') }
  let(:action) { described_class.new(user_repo: user_repo, profile_repo: profile_repo) }
  let(:user) { Factory.structs[:user] }
  let(:profile) { Factory.structs[:profile, user_id: user.id] }
  let(:params) { Hash[id: user.id, 'warden' => @warden] }
  let(:user_update) {
    user = Factory.structs[:user].to_h.reject { |k,v| [:id, :created_at, :updated_at].include?(k) }
    user[:profile] = { name: profile.name }
    user
  }
  let(:user_entity) { User.new(user.to_h.merge(profile: profile.to_h)) }

  context 'with valid params' do
    before(:each) do
      params[:user] = user_update
      expect(user_repo).to receive(:find_with_profile).with(user.id).and_return(user_entity)
      expect(user_repo).to receive(:update).with(user_entity.id, User.new(params[:user]))
      expect(profile_repo).to receive(:update).with(user_entity.profile.id, Profile.new(params[:user][:profile]))

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response).to have_http_status 302
    end

    it 'got a success messages' do
      expect(action.exposures[:flash][:info]).to eq ['User has been successfully updated']
    end

    it 'redirects to /users' do
      expect(@response).to redirect_to '/users'
    end
  end

  context 'with invalid params' do
    before(:each) do
      user_update[:email] = 'invalid email'
      params[:user] = user_update

      @response = action.call(params)
    end

    it 'return 422' do
      expect(@response).to have_http_status 422
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['Email is in invalid format']
    end
  end

  context 'edit non-existent user' do
    before(:each) do
      params[:user] = user_update
      expect(user_repo).to receive(:find_with_profile).with(user.id).and_return(nil)

      @response = action.call(params)
    end

    it 'return 404' do
      expect(@response).to have_http_status 404
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['User not found']
    end
  end
end
