require 'rails_helper'

RSpec.describe OpenLibraryService do
  let(:location) { 'denver,co' }
  let(:quantity) { 5 }
  let(:service) { OpenLibraryService.new(location, quantity) }

  describe '#search_books' do
    context 'with a successful API response' do
      let(:mock_response) do
        {
          'numFound' => 10,
          'docs' => [
            { 'title' => 'Book 1' },
            { 'title' => 'Book 2' }
          ]
        }
      end

      before do
        stub_request(:get, 'http://openlibrary.org/search.json')
          .with(query: { q: location, limit: quantity })
          .to_return(status: 200, body: mock_response.to_json, headers: {})
      end

      it 'returns the parsed JSON response' do
        result = service.search_books
        expect(result).to eq(mock_response)
      end
    end
    
  end
end
