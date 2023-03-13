# frozen_string_literal: true

module SleepRecords
  class Update < ApplicationService
    def initialize(sleep_record, params)
      @sleep_record = sleep_record
      @params = params
    end

    def call
      create_sleep_record
    end

    private

    attr_reader :sleep_record, :params

    def create_sleep_record
      updated = sleep_record.update(params)

      return { success: false, errors: sleep_record.errors } unless updated

      { success: true, data: sleep_record }
    end
  end
end
