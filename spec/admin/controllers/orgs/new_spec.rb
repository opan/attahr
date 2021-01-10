RSpec.describe Admin::Controllers::Orgs::New, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[user_id: @warden.user.id, 'warden' => @warden] }

  it 'return 200' do
    response = action.call(params)
    expect(response[0]).to eq 200
  end

  it 'exposes #org' do
    action.call(params)
    org = action.exposures[:org]

    expect(org).to eq Org.new
  end
end
