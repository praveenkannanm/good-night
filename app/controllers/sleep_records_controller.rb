class SleepRecordsController < ApplicationController
  before_action :set_sleep_record, only: %i[show update]

  # return all sleep records created within a week for the followers
  def index
    sleep_records = SleepRecord
                    .where(user_id: current_user.followers.select(:id))
                    .where('end_time >= ?', 1.week.ago)
                    .order(Arel.sql('end_time - start_time DESC'))
    response = { success: true, data: sleep_records }
    render_response(response, :ok)
  end

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
