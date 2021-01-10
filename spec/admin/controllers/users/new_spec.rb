RSpec.describe Admin::Controllers::Users::New, type: :action do
  let(:entity) { User.new }
  let(:action) { described_class.new(entity) }
  let(:params) { Hash['warden' => @warden] }

  it 'return 200' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end

  it 'exposes #user' do
    action.call(params)
    user = action.exposures[:user]

    expect(user).to eq entity
  end
end
