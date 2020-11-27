RSpec.describe Web::Controllers::Users::Index, type: :action do
  let(:repo) { UserRepository.new }
  let(:action) { described_class.new(repo) }
  let(:params) { Hash['warden' => @warden] }

  it 'exposes #users' do
    response = action.call(params)

    expect(action.exposures.fetch(:users).to_a).to eq repo.all_with_profile.to_a
  end

  it 'renders the user listings' do
    response = action.call(params)

    expect(action.users.to_a).to eq []
    expect(response[0]).to eq 200
  end
end
