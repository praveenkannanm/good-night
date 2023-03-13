# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :start_time, presence: true
  validate :validate_start_time

  def validate_start_time
    errors.add(:base, 'end_time cannot add without start_time') if start_time.nil? && end_time.present?
  end
end
