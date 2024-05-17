# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BattlesController, type: :controller do
  before(:each) do
    FactoryBot.create_list(:battle, 2)
  end

  context '#delete' do
    it 'should delete a battle correctly' do
      delete :destroy, params: { id: 1 }

      expect(response).to have_http_status(:see_other)
    end

    it 'should fail delete when battle does not exist' do
      delete :destroy, params: { id: 99 }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['message']).to eq('The battle does not exists.')
    end
  end
end
