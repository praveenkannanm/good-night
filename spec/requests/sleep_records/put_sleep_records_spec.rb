require 'rails_helper'

RSpec.describe 'PutSleepRecords', type: :request do
  subject do
    User.create!(name: 'Test User1', token: SecureRandom.urlsafe_base64(nil, false), password: '123456')
  end

  let!(:sleep_record) { subject.sleep_records.create!(start_time: Time.zone.now, end_time: nil) }

  context 'with valid params' do
    before do
      credentials = authenticate_with_token(subject.token)
      put(sleep_record_path(sleep_record.id), params:, headers: { 'Authorization' => credentials })
    end

    let(:end_time) { (Time.zone.now + 6.hours).to_s }
    let(:params) do
      {
        sleep_record: { end_time: }
      }
    end

    it 'responds with ok status' do
      expect(response).to have_http_status :ok
    end

    it 'should upated the end_time with given end_time' do
      sleep_record.reload
      expect(sleep_record.end_time).to eq(end_time)
    end
  end

  context 'with invalid params' do
    it 'should raise ActiveRecord::RecordNotFound for invalid record id' do
      expect do
        credentials = authenticate_with_token(subject.token)
        put(sleep_record_path(1_000_000), params: {}, headers: { 'Authorization' => credentials })
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should return error when sleep ends before start time' do
      params = { sleep_record: { end_time: (Time.now - 1.day).to_s } }
      credentials = authenticate_with_token(subject.token)
      put(sleep_record_path(sleep_record.id), params:, headers: { 'Authorization' => credentials })
      expect(response_json['errors']['end_time']).to eq(['end_time should be greater than start time'])
    end
  end
end
