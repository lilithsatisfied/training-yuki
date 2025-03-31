require 'rails_helper'

RSpec.describe 'Api::V1::Books', type: :request do
  describe 'GET /index' do
    it 'returns all books' do
      create_list(:book, 3)
      get '/api/v1/books', headers: { Accept: 'application/json' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
    end
  end
end
