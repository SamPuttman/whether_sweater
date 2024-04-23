require 'rails_helper'

RSpec.describe Api::V0::SessionsController, type: :controller do
  describe 'create' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      let(:valid_params) do
        {
          session: {
            email: user.email,
            password: user.password
          }
        }
      end

      it 'returns a 200 status code' do
        post :create, params: valid_params
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user with API key' do
        post :create, params: valid_params
        expect(JSON.parse(response.body)['data']['attributes']).to include('email', 'api_key')
      end
    end

    context 'with invalid credentials' do
      let(:invalid_params) do
        {
          session: {
            email: user.email,
            password: 'wrong_password'
          }
        }
      end

      it 'returns a 401 status code' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        post :create, params: invalid_params
        expect(JSON.parse(response.body)['error']).to eq('Invalid login')
      end
    end
  end
end
