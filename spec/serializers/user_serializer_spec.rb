require 'rails_helper'

RSpec.describe UserSerializer do
  let(:user) { create(:user) }
  let(:serializer) { described_class.new(user) }
  let(:serialized_data) { JSON.parse(serializer.to_json) }

  it 'includes the expected attributes' do
    expect(serialized_data['data']['attributes'].keys).to match_array(['email', 'api_key'])
  end
end
