require 'rails_helper'

RSpec.describe 'Book Search API', type: :request do
  describe 'book-search', :vcr do
    let(:location) { 'denver,co' }
    let(:quantity) { 5 }

    context 'with valid parameters' do
      it 'returns book search results for the given location', :vcr do
        get '/api/v0/book-search', params: { location: 'denver,co', quantity: 5 }

        expect(response).to be_successful
        expect(response.status).to eq(200)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:id]).to eq('null')
        expect(json[:data][:type]).to eq('books')
        expect(json[:data][:attributes][:destination]).to eq('denver,co')
        expect(json[:data][:attributes][:forecast]).to be_a(Hash)
        expect(json[:data][:attributes][:total_books_found]).to be_an(Integer)
        expect(json[:data][:attributes][:books]).to be_an(Array)
        expect(json[:data][:attributes][:books].size).to eq(5)
      end

      it 'returns the book search results' do
        get "/api/v0/book-search?location=#{location}&quantity=#{quantity}"

        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error for missing location' do
        get "/api/v0/book-search?quantity=#{quantity}"

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid parameters' })
      end

      it 'returns an error for invalid quantity' do
        get "/api/v0/book-search?location=#{location}&quantity=-1"

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid parameters' })
      end
    end

    context 'with location not found' do
      let(:invalid_location) { 'invalidcity,invalidstate' }

      it 'returns an error' do
        get "/api/v0/book-search?location=#{invalid_location}&quantity=#{quantity}"

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Location not found' })
      end
    end
  end
end
