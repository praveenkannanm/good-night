require 'rails_helper'

RSpec.describe 'PostSleepRecords', type: :request do
  subject do
    User.create!(name: 'Test User1', token: SecureRandom.urlsafe_base64(nil, false), password: '123456')
  end

  before do
    credentials = authenticate_with_token(subject.token)
    post(sleep_records_path, params:, headers: { 'Authorization' => credentials })
  end

  context 'with valid params' do
    let(:start_time) { Time.zone.now.to_s }
    let(:params) do
      {
        sleep_record: { start_time: }
      }
    end

    it 'responds with created status' do
      expect(response).to have_http_status :created
    end

    it 'should return the sleep recrod' do
      expect(response_json['success']).to be_truthy
    end

    it 'should return the sleep recrod with given start_time' do
      sleep_record = SleepRecord.find response_json['data']['id']
      expect(sleep_record.start_time.to_s).to eq(start_time)
    end
  end

  context 'with invalid parameters' do
    let(:params) do
      {
        sleep_record: { start_time: nil }
      }
    end
    it 'returns a unprocessable entity status' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns a error message' do
      expect(response_json['errors']['start_time'][0]).to eq("can't be blank")
    end
  end
end
