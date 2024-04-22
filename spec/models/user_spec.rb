require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should have_secure_password }
  end

  describe 'callbacks' do
    it 'generates an API key on create' do
      user = create(:user)
      expect(user.api_key).to be_present
    end
  end
end
