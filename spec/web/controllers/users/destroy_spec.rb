RSpec.describe Web::Controllers::Users::Destroy, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[id: 1, 'warden' => @warden] }

  it 'is successful' do
    response = action.call(params)
    flash = action.exposures[:flash]
    expect(response[0]).to eq 302
    expect(flash[:info]).to eq [I18n.t('users.success.delete')]
  end
end
