require 'rails_helper'

RSpec.describe 'Book Search API' do
  describe 'book search' do
    context 'with valid parameters' do
      it 'returns book search results for the given location', :vcr do
        get '/api/v0/book-search', params: { location: 'denver,co', quantity: 5 }

        expect(response).to be_successful
        expect(response.status).to eq(200)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:id]).to eq(nil)
        expect(json[:data][:type]).to eq('books')
        expect(json[:data][:attributes][:destination]).to eq('denver,co')
        expect(json[:data][:attributes][:forecast]).to be_a(Hash)
        expect(json[:data][:attributes][:total_books_found]).to be_an(Integer)
        expect(json[:data][:attributes][:books]).to be_an(Array)
        expect(json[:data][:attributes][:books].size).to eq(5)
      end
    end

    context 'with missing location parameter' do
      it 'returns an error response' do
        get '/api/v0/book-search', params: { quantity: 5 }

        expect(response).to have_http_status(:bad_request)

        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:error]).to eq('Location parameter is missing')
      end
    end

    context 'with invalid quantity parameter' do
      it 'returns an error response' do
        get '/api/v0/book-search', params: { location: 'denver,co', quantity: 0 }

        expect(response).to have_http_status(:bad_request)

        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:error]).to eq('A valid quantity is required')
      end
    end

    context 'with location not found' do
      it 'returns an error', :vcr do
        get '/api/v0/book-search', params: { location: 'invalid_location', quantity: 5 }

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:error]).to eq('Location not found')
      end
    end
  end
end
