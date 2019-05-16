RSpec.describe Web::Controllers::User::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }

  it 'renders the user listings' do
    response = action.call(params)

    expect(response[0]).to eq 200
  end
end
