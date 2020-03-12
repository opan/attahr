RSpec.describe Web::Controllers::Users::Index, type: :action do
  let(:repo) { UserRepository.new }
  let(:action) { described_class.new(repo) }
  let(:params) { Hash[] }

  it 'exposes #users' do
    expect(repo).to receive(:all).and_return([repo])
    response = action.call(params)

    expect(action.exposures.fetch(:users)).to eq [repo]
  end

  it 'renders the user listings' do
    expect(repo).to receive(:all).and_return([User.new])
    response = action.call(params)

    expect(action.users).to eq [User.new]
    expect(response[0]).to eq 200
  end
end
