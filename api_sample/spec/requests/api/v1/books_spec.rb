require 'rails_helper'

RSpec.describe 'Api::V1::Books', type: :request do
  let!(:user) { create(:user, name: 'yuki', password: 'password123') }

  describe 'GET /index' do
    context 'when user is logged in' do
      before do
        post '/api/v1/login', params: { name: 'yuki', password: 'password123' }
      end

      it 'returns all books' do
        create_list(:book, 3)
        get '/api/v1/books', headers: { Accept: 'application/json' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.length).to eq(3)
      end
    end

    context 'when user is not logged in' do
      it 'returns unauthorized status' do
        get '/api/v1/books'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
