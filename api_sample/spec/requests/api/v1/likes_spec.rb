require 'rails_helper'

RSpec.describe 'Api::V1::Likes', type: :request do
  let!(:user) { create(:user, name: 'tester', password: 'password123') }
  let!(:post_record) { create(:post, user: user) }

  describe 'POST /posts/:id/like' do
    context 'when logged in' do
      before do
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
      end

      it 'likes a post' do
        post "/api/v1/posts/#{post_record.id}/like"
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('いいねしました')
      end

      it 'returns error when already liked' do
        user.likes.create!(post: post_record)
        post "/api/v1/posts/#{post_record.id}/like"
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        post "/api/v1/posts/#{post_record.id}/like"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /posts/:id/unlike' do
    context 'when logged in' do
      before do
        user.likes.create!(post: post_record)
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
      end

      it 'unlikes a post' do
        post "/api/v1/posts/#{post_record.id}/unlike"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('いいねを解除しました')
      end

      it 'returns error if not liked yet' do
        user.likes.destroy_all
        post "/api/v1/posts/#{post_record.id}/unlike"
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('いいねしていません')
      end
    end
  end
end
