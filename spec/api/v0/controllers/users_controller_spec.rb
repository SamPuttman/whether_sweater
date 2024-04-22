require 'rails_helper'

RSpec.describe Api::V0::UsersController, type: :controller do
  describe 'create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            email: 'test@example.com',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it 'creates a new user' do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it 'returns a 201 status code' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'returns the created user with API key' do
        post :create, params: valid_params
        expect(JSON.parse(response.body)['data']['attributes']).to include('email', 'api_key')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            email: '',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it 'does not create a new user' do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end

      it 'returns a 422 status code' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error messages' do
        post :create, params: invalid_params
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end
end
