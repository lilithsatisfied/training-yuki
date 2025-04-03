require 'rails_helper'

RSpec.describe 'Api::V1::Follows', type: :request do
  let!(:follower) { create(:user, name: 'follower', password: 'password123') }
  let!(:followee) { create(:user, name: 'followee', password: 'password123') }

  describe 'POST /users/:id/follow' do
    context 'when logged in' do
      before do
        post '/api/v1/login', params: { name: follower.name, password: 'password123' }
      end

      it 'creates a follow' do
        post "/api/v1/users/#{followee.id}/follow", headers: { Accept: 'application/json' }
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('フォローしました')
      end

      it 'does not allow duplicate follow' do
        follower.follow!(followee) # 事前にフォローしておく
        post "/api/v1/users/#{followee.id}/follow"
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        post "/api/v1/users/#{followee.id}/follow"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /users/:id/unfollow' do
    context 'when logged in' do
      before do
        follower.follow!(followee)
        post '/api/v1/login', params: { name: follower.name, password: 'password123' }
      end

      it 'removes a follow' do
        post "/api/v1/users/#{followee.id}/unfollow", headers: { Accept: 'application/json' }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('フォロー解除しました')
      end

      it 'returns error if not following' do
        follower.active_follows.destroy_all # 事前に解除しておく
        post "/api/v1/users/#{followee.id}/unfollow"
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('フォローしていません')
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        post "/api/v1/users/#{followee.id}/unfollow"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
