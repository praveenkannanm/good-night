# frozen_string_literal: true

class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followee_id }, presence: true
  validates :followee_id, uniqueness: { scope: :follower_id }, presence: true
end
