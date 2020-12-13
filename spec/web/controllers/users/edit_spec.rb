RSpec.describe Web::Controllers::Users::Edit, type: :action do
  let(:repository) { instance_double('UserRepository') }
  let(:action) { described_class.new(repository: repository) }
  let(:params) { Hash[user: {}, 'warden' => @warden] }

  context 'when user exists' do
    before(:each) do
      params[:id] = 1

      expect(repository).to receive(:find).with(params[:id]).and_return(User.new(id: 1, username: 'foo'))
      @response = action.call(params)
    end

    it 'is successful' do
      expect(@response[0]).to eq 200
    end

    it 'expose #user' do
      expect(action.exposures[:user].username).to eq 'foo'
    end
  end

  context 'when user does not exists' do
    before(:each) do
      params[:id] = 1

      expect(repository).to receive(:find).with(params[:id]).and_return(nil)
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
