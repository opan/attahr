RSpec.describe Admin::Controllers::Users::Destroy, type: :action do
  let(:user_repo) { instance_double('UserRepository') }
  let(:user) { Factory.structs[:user] }
  let(:action) { described_class.new(user_repo: user_repo) }
  let(:params) { Hash[id: user.id, 'warden' => WardenDouble] }

  context 'with valid ID' do
    before(:each) do
      expect(user_repo).to receive(:find).with(user.id).and_return user
      expect(user_repo).to receive(:delete).with(user.id)

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response).to have_http_status 302
    end

    it 'got a success messages' do
      expect(action.exposures[:flash][:info]).to eq [I18n.t('users.success.delete')]
    end
  end

  context 'with invalid ID' do
    before(:each) do
      expect(user_repo).to receive(:find).with(user.id).and_return nil

      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response).to have_http_status 302
    end

    it 'got a success messages' do
      expect(action.exposures[:flash][:errors]).to eq ['User not found']
    end
  end
end
