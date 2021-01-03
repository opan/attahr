RSpec.describe Web::Controllers::Users::Update, type: :action do
  let(:user_repo) { instance_double('UserRepository') }
  let(:profile_repo) { instance_double('ProfileRepository') }
  let(:action) { described_class.new(user_repo: user_repo, profile_repo: profile_repo) }
  let(:params) { Hash[user: {}, 'warden' => @warden] }
  let(:user) { User.new(id: 555, email: 'foo@mail.com', username: 'foo', profile: Profile.new(id: 666, name: 'foo')) }

  context 'with valid params' do
    before(:each) do
      params[:user] = {
        email: 'new-email@mail.com',
        username: 'new-name',
        profile: {
          name: 'name',
        },
      }
      expect(user_repo).to receive(:find_by_email_with_profile).with(params[:user][:email]).and_return(user)
      expect(user_repo).to receive(:update).with(user.id, User.new(params[:user]))
      expect(profile_repo).to receive(:update).with(user.profile.id, Profile.new(params[:user][:profile]))

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'got a success messages' do
      expect(action.exposures[:flash][:info]).to eq ['User has been successfully updated']
    end

    it 'redirects to /users' do
      expect(@response[1]['Location']).to eq '/users'
    end
  end

  context 'with invalid params' do
    before(:each) do
      params[:user] = {
        email: 'new-email',
        username: 'new-name',
        profile: {
          name: 'name',
        },
      }

      @response = action.call(params)
    end

    it 'return 422' do
      expect(@response[0]).to eq 422
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['Email is in invalid format']
    end
  end

  context 'edit non-existent user' do
    before(:each) do
      params[:user] = {
        email: 'new-email@mail.com',
        username: 'new-name',
        profile: {
          name: 'name',
        },
      }
      expect(user_repo).to receive(:find_by_email_with_profile).with(params[:user][:email]).and_return(nil)

      @response = action.call(params)
    end

    it 'return 404' do
      expect(@response[0]).to eq 404
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq ['User not found']
    end
  end
end
