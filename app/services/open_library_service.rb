class OpenLibraryService
  def initialize(location, quantity)
    @location = location
    @quantity = quantity
  end

  def search_books
    conn = Faraday.new(url: 'http://openlibrary.org')
    response = conn.get('/search.json', {
      q: @location,
      limit: @quantity
    })
    JSON.parse(response.body)
  end
end
