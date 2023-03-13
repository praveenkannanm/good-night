# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :start_time, presence: true
  validate :validate_start_time
  validate :validate_time

  def validate_start_time
    errors.add(:base, 'end_time cannot add without start_time') if start_time.nil? && end_time.present?
  end

  def validate_time
    errors.add(:end_time, 'end_time should be greater than start time') if sleep_ends_before_start_time?
  end

  def sleep_ends_before_start_time?
    return false unless start_time.present? && end_time.present?

    start_time > end_time
  end
end
