require 'rails_helper'

RSpec.describe MapQuestService do
  describe 'coordinates' do
    context 'when the API call is successful' do
      it 'returns latitude and longitude', :vcr do
        service = MapQuestService.new('Denver', 'CO')
        expect(service.coordinates).to eq([39.74001, -104.99202])
      end
    end

    context 'when the location is invalid' do
      it 'returns nil value', :vcr do
        service = MapQuestService.new('ThisIsDefinitelyNotAPlace', 'XYZ')
        expect(service.coordinates).to eq(nil)
      end
    end
  end
end
