RSpec.describe Web::Controllers::Sessions::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { {'warden' => double('Warden', user: 'current_user')} }

  it 'is successful' do
    allow(action).to receive(:authenticate!).and_return(true)
    response = action.call(params.merge({user: { email: 'foo@email.com', password: '123'}}))
    expect(response[0]).to eq 302
    expect(action.exposures[:params].valid?).to be_truthy
    expect(response).to redirect_to('/')
  end

  it 'is failed with incorrect params' do
    allow(action).to receive(:authenticate!).and_return(true)
    response = action.call(params)
    expect(action.exposures[:params].valid?).not_to be_truthy
    expect(response).to redirect_to('/sign_in')
  end
end
