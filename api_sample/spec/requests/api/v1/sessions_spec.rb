require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  let!(:user) { create(:user, name: 'yuki', password: 'password123') }

  describe 'POST /login' do
    context 'with valid credentials' do
      it 'returns a success response with user info' do
        post '/api/v1/login', params: { name: 'yuki', password: 'password123' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('ログイン成功').or eq('Logged in')
        expect(json['user_id']).to eq(user.id)
      end

      it 'sets session with user_id' do
        post '/api/v1/login', params: { name: 'yuki', password: 'password123' }

        expect(response).to have_http_status(:ok)
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'with invalid credentials' do
      it 'returns an unauthorized response' do
        post '/api/v1/login', params: { name: 'yuki', password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end
  end

  describe 'DELETE /logout' do
    it 'logs out the user' do
      post '/api/v1/login', params: { name: 'yuki', password: 'password123' }
      delete '/api/v1/logout'

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('ログアウトしました')
    end
  end

  describe 'GET /me' do
    context 'when logged in' do
      it 'returns current user info' do
        post '/api/v1/login', params: { name: user.name, password: 'password123' }
        get '/api/v1/me'

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['name']).to eq(user.name)
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        get '/api/v1/me'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
