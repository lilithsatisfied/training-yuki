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
        create_list(:post, 15, user:)
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
      end

      it 'returns a paginated list of posts' do
        get '/api/v1/posts', params: { page: 1, per_page: 10 }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        # 投稿データの検証
        expect(json['posts'].length).to eq(10)
        expect(json['posts'].first).to include('id', 'content', 'user_name')

        # ページネーション情報の検証
        expect(json['pagination']).to include('current_page', 'total_pages', 'total_count', 'next_page', 'prev_page')
        expect(json['pagination']['current_page']).to eq(1)
        expect(json['pagination']['total_count']).to eq(15)
        expect(json['pagination']['next_page']).to eq(2)
        expect(json['pagination']['prev_page']).to be_nil
      end

      it 'returns the second page of posts' do
        get '/api/v1/posts', params: { page: 2, per_page: 10 }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        # 投稿データの検証
        expect(json['posts'].length).to eq(5) # 2ページ目には5件のみ

        # ページネーション情報の検証
        expect(json['pagination']['current_page']).to eq(2)
        expect(json['pagination']['next_page']).to be_nil
        expect(json['pagination']['prev_page']).to eq(1)
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
        get '/api/v1/posts/999999' # 存在しないID
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
