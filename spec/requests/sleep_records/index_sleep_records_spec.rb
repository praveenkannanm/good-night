require 'rails_helper'

RSpec.describe 'IndexSleepRecords', type: :request do
  subject do
    User.create!(name: 'Test User1', token: SecureRandom.urlsafe_base64(nil, false), password: '123456')
  end

  before do
    create_record
    credentials = authenticate_with_token(subject.token)
    get(sleep_records_path, headers: { 'Authorization' => credentials })
  end

  it 'should return sleep records of following users for a week' do
    expect(response_json['data'].count).to eq(2)
  end

  it 'should return followers sleep records created within a week' do
    ids = response_json['data'].map { |sleep_record| sleep_record['id'] }
    expect(ids.sort).to eq([@sleep_record1.id, @sleep_record2.id].sort)
  end

  it 'should return the sleep records ordered by the length of their sleep' do
    ids = response_json['data'].map { |sleep_record| sleep_record['id'] }
    expect(ids).to eq([@sleep_record2.id, @sleep_record1.id])
  end

  it 'should return the sleep records only create within a week' do
    user = User.create!(name: 'Test User3', token: SecureRandom.urlsafe_base64(nil, false), password: '123456')
    Users::Follow.call(subject, user.id)
    start_time = Time.now - 2.weeks
    user.sleep_records.create(start_time:, end_time: start_time + 3.hours)
    expect(response_json['data'].count).to eq(2)
  end
end

def create_record
  user1 = User.create!(name: 'Test User2', token: SecureRandom.urlsafe_base64(nil, false), password: '123456')
  user2 = User.create!(name: 'Test User3', token: SecureRandom.urlsafe_base64(nil, false), password: '123456')
  Users::Follow.call(subject, user1.id)
  Users::Follow.call(subject, user2.id)
  @sleep_record1 = user1.sleep_records.create(start_time: Time.now, end_time: Time.now + 2.hours)
  @sleep_record2 = user2.sleep_records.create(start_time: Time.now, end_time: Time.now + 7.hours)
end
