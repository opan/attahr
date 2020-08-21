RSpec.describe Web::Controllers::Sessions::New, type: :action do
  let(:action) { described_class.new }
  let(:params) { {'warden' => double('Warden', user: 'current_user')} }

  before(:each) do
    allow(action).to receive(:authenticated?).and_return(false)
  end

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end
end
