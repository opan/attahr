RSpec.describe Web::Controllers::User::New, type: :action do
  let(:repo) { UserRepository.new }
  let(:action) { described_class.new(repo) }
  let(:params) { Hash[] }

  it 'return 200' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end

  it 'exposes #user' do
    action.call(params)
    user = action.exposures[:user]

    expect(user).to eq repo
  end
end
