RSpec.describe Web::Controllers::Users::Edit, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[user: {}, 'warden' => @warden] }

  it 'is successful' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end
end
