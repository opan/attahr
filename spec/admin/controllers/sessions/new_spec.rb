RSpec.describe Admin::Controllers::Sessions::New, type: :action do
  let(:action) { described_class.new }
  let(:params) { {'warden' => double('Warden', user: 'current_user', message: '')} }

  before(:each) do
  end

  context 'when not signed in' do
    it 'is successful' do
      allow(action).to receive(:authenticated?).and_return(false)
      response = action.call(params)
      expect(response[0]).to eq 200
    end
  end

  context 'when already signed in' do
    it 'is successful' do
      allow(action).to receive(:authenticated?).and_return(true)
      response = action.call(params)
      expect(response[0]).to eq 302
      expect(response).to redirect_to(Admin.routes.root_path.delete_suffix('/'))
    end
  end
end
