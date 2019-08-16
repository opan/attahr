RSpec.describe Web::Controllers::Users::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[user: {}] }

  context 'with valid params' do
    before(:each) do
      params[:user][:email] = 'foo@email.com'
      params[:user][:username] = 'foo'
      @response = action.call(params)
    end

    it 'return 302' do
      expect(@response[0]).to eq 302
    end

    it 'expose #user' do
      expect(action.exposures[:user].email).to eq 'foo@email.com'
    end

    it 'redirects to /users' do
      expect(@response[1]['Location']).to eq '/users'
    end
  end

  context 'with invalid params' do
    before(:each) do
      params[:user][:email] = 'foo'
      params[:user][:username] = 'foo'
    end

    it 'return 422' do
      response = action.call(params)
      expect(response[0]).to eq 422
    end

    context 'with invalid email' do
      it 'return error messages email not valid' do
        action.call(params)
        flash = action.exposures[:flash]

        expect(flash[:errors]).to eq [I18n.t('errors.format?', field: 'Email')]
      end
    end
  end
end
