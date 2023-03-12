# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe 'associations' do
    it { should belong_to(:follower) }

    it { should belong_to(:follower) }
  end

  describe 'validations' do
    subject { Follow.create(follower_id: 1, followee_id: 2) }
    it { should validate_uniqueness_of(:follower_id).scoped_to(:followee_id) }
    it { should validate_uniqueness_of(:followee_id).scoped_to(:follower_id) }
  end
end
