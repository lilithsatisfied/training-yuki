require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  let!(:user) { create(:user, name: 'yuki', password: 'password123') }

  describe 'GET /users/:id' do
    context 'when logged in' do
      it 'returns user info as JSON' do
        # ログインしてセッション確立
        post '/api/v1/login', params: { name: 'yuki', password: 'password123' }, headers: { Accept: 'application/json' }

        get "/api/v1/users/#{user.id}", headers: { Accept: 'application/json' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['id']).to eq(user.id)
        expect(json['name']).to eq('yuki')
      end
    end

    context 'when not logged in' do
      it 'returns unauthorized' do
        get "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
