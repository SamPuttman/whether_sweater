require 'rails_helper'

RSpec.describe BookSearchFacade do
  describe '.search' do
    let(:location) { 'denver,co' }
    let(:quantity) { 5 }

    context 'with valid location and quantity' do
      before do
        allow(MapQuestService).to receive_message_chain(:new, :coordinates).and_return([39.7392, -104.9903])
        allow(WeatherService).to receive_message_chain(:new, :forecast).and_return({ 'current' => { 'temp_f' => 70 } })
        allow(OpenLibraryService).to receive_message_chain(:new, :search_books).and_return({ 'numFound' => 10, 'docs' => [{ 'title' => 'Star Wars' }, { 'title' => 'Star Trek' }] })
      end

      it 'returns the search results' do
        result = BookSearchFacade.search(location, quantity)
        expect(result[:destination]).to eq(location)
        expect(result[:total_books_found]).to eq(10)
        expect(result[:books].size).to eq(2)
      end
    end

    context 'with missing city or state' do
      it 'returns an error' do
        result = BookSearchFacade.search('denver,', quantity)
        expect(result).to eq({ error: 'Both city and state must be provided' })
      end
    end

    context 'with location not found' do
      before do
        allow(MapQuestService).to receive_message_chain(:new, :coordinates).and_return([nil, nil])
      end

      it 'returns an error' do
        result = BookSearchFacade.search(location, quantity)
        expect(result).to eq({ error: 'Location not found' })
      end
    end

    context 'with weather data not available' do
      before do
        allow(MapQuestService).to receive_message_chain(:new, :coordinates).and_return([39.7392, -104.9903])
        allow(WeatherService).to receive_message_chain(:new, :forecast).and_return(nil)
      end

      it 'returns an error' do
        result = BookSearchFacade.search(location, quantity)
        expect(result).to eq({ error: 'Weather data not available' })
      end
    end
  end
end
