class SleepRecordsController < ApplicationController
  before_action :set_sleep_record, only: %i[show update destroy]

  # Create Sleep record with start time
  def create
    result = SleepRecords::Create.call(current_user, sleep_record_params)
    render_response(result, :created)
  end


  private

  def set_sleep_record
    @sleep_record = current_user.sleep_records.find(params[:id])
  end

  def sleep_record_params
    params.require(:sleep_record).permit(:id, :start_time, :end_time)
  end
end
