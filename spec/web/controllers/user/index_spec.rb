RSpec.describe Web::Controllers::User::Index, type: :action do
  let(:repo) { UserRepository.new }
  let(:action) { described_class.new(repo) }
  let(:params) { Hash[] }

  it 'renders the user listings' do
    expect(repo).to receive(:all).and_return([User.new])
    response = action.call(params)

    expect(action.users).to eq [User.new]
    expect(response[0]).to eq 200
  end
end
