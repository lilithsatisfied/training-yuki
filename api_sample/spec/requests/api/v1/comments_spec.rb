require 'rails_helper'

RSpec.describe 'Api::V1::Comments', type: :request do
  let!(:user) { create(:user, name: 'tester', password: 'password123') }
  let!(:post_record) { create(:post, user: user) }

  describe 'POST /posts/:id/comments' do
    context 'when logged in' do
      before do
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
      end

      it 'creates a comment with valid content' do
        post "/api/v1/posts/#{post_record.id}/comments", params: { comment: { content: 'Nice post!' } }

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('コメントを投稿しました')
        expect(json['comment']['content']).to eq('Nice post!')
        expect(json['comment']['user_name']).to eq('tester')
      end

      it 'returns error when content is blank' do
        post "/api/v1/posts/#{post_record.id}/comments", params: { comment: { content: '' } }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        post "/api/v1/posts/#{post_record.id}/comments", params: { comment: { content: 'Test' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when post does not exist' do
      before do
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
      end

      it 'returns not found' do
        post "/api/v1/posts/999999/comments", params: { comment: { content: 'Test' } }
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('投稿が見つかりません')
      end
    end
  end
end
