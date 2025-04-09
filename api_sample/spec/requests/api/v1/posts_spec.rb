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
        expect(json['post']['content']).to eq('This is a test post')
        expect(json['post']['user_name']).to eq('tester')
      end

      it 'returns error when content is blank' do
        post '/api/v1/posts', params: { post: { content: '' } }

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
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
        expect(json.first).to include('id', 'content', 'user_name')
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        get '/api/v1/posts'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /posts/:id' do
    let!(:post_record) { create(:post, user: user, content: '詳細テスト投稿') }

    context 'when logged in' do
      before do
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
      end

      it 'returns the post details' do
        get "/api/v1/posts/#{post_record.id}"

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['id']).to eq(post_record.id)
        expect(json['content']).to eq('詳細テスト投稿')
        expect(json['user_name']).to eq('tester')
      end
    end

    context 'when post not found' do
      before do
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
      end

      it 'returns not found status' do
        get '/api/v1/posts/999999'  # 存在しないID
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('投稿が見つかりません')
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        get "/api/v1/posts/#{post_record.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
