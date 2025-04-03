# spec/requests/api/v1/posts_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Posts', type: :request do
  let!(:user) { create(:user, name: 'tester', password: 'password123') }

  describe 'POST /posts' do
    context 'when logged in' do
      before do
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
      end

      it 'creates a post with valid content' do
        post '/api/v1/posts', params: { post: { content: 'This is a test post' } }

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('投稿を作成しました')
      end

      it 'returns error when content is blank' do
        post '/api/v1/posts', params: { post: { content: '' } }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        post '/api/v1/posts', params: { post: { content: 'test' } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /posts' do
    context 'when logged in' do
      before do
        create_list(:post, 3, user:)
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
      end

      it 'returns a list of posts' do
        get '/api/v1/posts'
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.length).to eq(3)
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        get '/api/v1/posts'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
