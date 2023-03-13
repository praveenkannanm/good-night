require 'rails_helper'

RSpec.describe 'Follows', type: :request do
  subject do
    User.create!(name: 'Test User1', token: SecureRandom.urlsafe_base64(nil, false), password: '123456')
  end

  let(:user2) do
    User.create(name: 'Test User2', token: SecureRandom.urlsafe_base64(nil, false), password: '123789')
  end

  before do
    credentials = authenticate_with_token(subject.token)
    params = {
      follow_id: user2.id
    }
    post(follows_path, params:, headers: { 'Authorization' => credentials })
  end

  describe 'POST /follows' do
    context 'with valid params' do
      it 'responds with created status' do
        expect(response).to have_http_status :created
      end

      it 'should increase the follower count' do
        expect(subject.followers.count).to eq(1)
      end

      it 'should return the followed user' do
        follower = subject.followers.find_by_id user2.id
        expect(follower.id).to eq(user2.id)
      end
    end

    context 'with invalid parameters' do
      before do
        credentials = authenticate_with_token(subject.token)
        params = {
          follow_id: user2.id
        }
        post(follows_path, params:, headers: { 'Authorization' => credentials })
      end
      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a error message' do
        expect(response_json['error']).to eq('already following the user')
      end
    end
  end

  describe 'DELETE /follows' do
    context 'with valid params' do
      before do
        credentials = authenticate_with_token(subject.token)
        delete(follow_path(user2.id), headers: { 'Authorization' => credentials })
      end
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'should decrease the follower count' do
        expect(subject.followers.count).to eq(0)
      end
    end

    context 'with invalid parameters' do
      before do
        credentials = authenticate_with_token(subject.token)
        delete(follow_path(9_090_000), headers: { 'Authorization' => credentials })
      end
      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
