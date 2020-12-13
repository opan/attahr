RSpec.describe Web::Controllers::Users::Update, type: :action do
  let(:repository) { instance_double('UserRepository') }
  let(:action) { described_class.new(repository: repository) }
  let(:params) { Hash[user: {}, 'warden' => @warden] }

  context 'with valid params' do

    before(:each) do
      params[:user] = {
        email: 'new-email@mail.com',
        username: 'new-name',
        profile: {
          name: 'name',
        },
      }
      expect(repository).to receive(:find_by_email).with(params[:user][:email]).and_return(User.new(id: 555))
      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'expose #user' do
      expect(action.exposures[:user].id).to eq 555
    end

    it 'got a success messages' do
      expect(action.exposures[:flash][:info]).to eq 'User has been successfully updated'
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
      expect(action.exposures[:flash][:errors]).to eq ["Email is in invalid format"]
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
      expect(repository).to receive(:find_by_email).with(params[:user][:email]).and_return(nil)

      @response = action.call(params)
    end

    it 'return 404' do
      expect(@response[0]).to eq 404
    end

    it 'got an errors messages' do
      expect(action.exposures[:flash][:errors]).to eq "User not found"
    end
  end
end
