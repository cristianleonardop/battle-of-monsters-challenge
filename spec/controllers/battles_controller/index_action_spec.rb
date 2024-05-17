# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BattlesController, type: :controller do
  before(:each) do
    FactoryBot.create_list(:battle, 2)
  end

  context '#index' do
    it 'should get all battles correctly' do
      get :index
      response_data = JSON.parse(response.body)['data']

      expect(response).to have_http_status(:ok)
      expect(response_data.count).to eq(2)
    end
  end
end
