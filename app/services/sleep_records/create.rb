# frozen_string_literal: true

module SleepRecords
  class Create < ApplicationService
    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      create_sleep_record
    end

    private

    attr_reader :user, :params

    def create_sleep_record
      sleep_record = user.sleep_records.create(params)

      return { success: false, errors: sleep_record.errors } if sleep_record.errors.any?

      { success: true, data: sleep_record }
    end
  end
end
