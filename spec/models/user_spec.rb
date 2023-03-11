require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sleep_records) }
    it { should have_many(:followed_users).class_name('Follow') }
    it { should have_many(:followees) }
    it { should have_many(:following_users).class_name('Follow') }
    it { should have_many(:followers) }
  end
end
