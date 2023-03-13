require 'rails_helper'

RSpec.describe 'PostSleepRecords', type: :request do
  subject do
    User.create!(name: 'Test User1', token: SecureRandom.urlsafe_base64(nil, false), password: '123456')
  end
  context 'with valid params' do
    before do
      credentials = authenticate_with_token(subject.token)
      get(sleep_record_path(id), headers: { 'Authorization' => credentials })
    end
    let(:id) do
      sleep_record = subject.sleep_records.create(start_time: Time.zone.now, end_time: Time.zone.now + 6.hours)
      sleep_record.id
    end
    it 'should return sleep recrod' do
      expect(response).to have_http_status :ok
    end

    it 'should return sleep recrod' do
      expect(response_json['success']).to be_truthy
    end
  end

  context 'with invalid params' do
    let(:id) { 100_000 }
    it 'should raise ActiveRecord::RecordNotFound' do
      expect do
        credentials = authenticate_with_token(subject.token)
        get(sleep_record_path(id), headers: { 'Authorization' => credentials })
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
