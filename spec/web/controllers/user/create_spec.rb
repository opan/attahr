RSpec.describe Web::Controllers::User::Create, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }

  context 'with valid params' do
    it 'redirects the user to the listings user' do
      params[:email] = 'foo@email.com'
      params[:username] = 'foo'
      response = action.call(params)

      expect(response[0]).to eq 302
      expect(response[1]['Location']).to eq '/users'
    end
  end

  context 'with invalid params' do
    context 'with invalid email' do
      it 'return errors message email not valid' do
        params[:email] = 'foo'
        response = action.call(params)

        expect(response[0]).to eq 422
      end
    end

    it 're-renders create user page' do
      response = action.call(params)

      expect(response[0]).to eq 422
    end
  end
end
