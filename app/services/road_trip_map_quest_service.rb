class RoadTripMapQuestService
  def initialize(origin, destination)
    @origin = origin
    @destination = destination
  end

  def directions
    conn = Faraday.new(url: 'http://www.mapquestapi.com')
    response = conn.get('/directions/v2/route', {
      key: Rails.application.credentials.mapquest[:api_key],
      from: @origin,
      to: @destination
    })
    JSON.parse(response.body, symbolize_names: true)
  end

  def travel_time(directions_data)
    if directions_data[:info][:statuscode] == 0
      @seconds = directions_data[:route][:time]
      format_travel_time(@seconds)
    else
      "impossible"
    end
  end

  def arrival_time
    return nil if @seconds.nil?
    (Time.now + @seconds).to_datetime
  end

  private

  def format_travel_time(seconds)
    return "impossible" if seconds == "impossible" || seconds.nil?

    hours, remainder = seconds.divmod(3600)
    minutes, _seconds = remainder.divmod(60)

    formatted_time = "#{hours} hours, #{minutes} minutes"
  end
end
