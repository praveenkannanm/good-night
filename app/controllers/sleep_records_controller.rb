class SleepRecordsController < ApplicationController
  before_action :set_sleep_record, only: %i[show edit update destroy]

  # return the created sleep record to show details
  def show
    result = { success: true, data: @sleep_record }
    render_response(result, :ok)
  end

  # Create Sleep record with start time
  def create
    result = SleepRecords::Create.call(current_user, sleep_record_params)
    render_response(result, :created)
  end

  # Updated the started sleep record with end_time
  def update
    result = SleepRecords::Update.call(@sleep_record, sleep_record_params)
    render_response(result, :ok)
  end

  private

  def set_sleep_record
    @sleep_record = current_user.sleep_records.find(params[:id])
  end

  def sleep_record_params
    params.require(:sleep_record).permit(:id, :start_time, :end_time)
  end
end
