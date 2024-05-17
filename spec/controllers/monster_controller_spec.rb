# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonstersController, type: :controller do
  def create_monsters
    FactoryBot.create_list(:monster, 1)
  end

  it 'should get all monsters correctly' do
    create_monsters
    get :index
    response_data = JSON.parse(response.body)['data']

    expect(response).to have_http_status(:ok)
    expect(response_data[0]['name']).to eq('My monster Test')
  end

  it 'should get a single monster correctly' do
    create_monsters
    get :show, params: { id: 1 }
    response_data = JSON.parse(response.body)['data']

    expect(response).to have_http_status(:ok)
    expect(response_data['name']).to eq('My monster Test')
  end

  it 'should get 404 error if monster does not exists' do
    get :show, params: { id: 99 }

    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
  end

  it 'should create a new monster' do
    monster_attributes = FactoryBot.attributes_for(:monster)

    post :create, params: { monster: monster_attributes }

    response_data = JSON.parse(response.body)['data']

    expect(response).to have_http_status(:created)
    expect(response_data['name']).to eq('My monster Test')
  end

  it 'should update a monster correctly' do
    create_monsters
    monster_attributes = FactoryBot.attributes_for(:monster)
    put :update, params: { id: 1, monster: monster_attributes }

    expect(response).to have_http_status(:ok)
  end

  it 'should fail update when monster does not exist' do
    monster_attributes = FactoryBot.attributes_for(:monster)
    put :update, params: { id: 99, monster: monster_attributes }

    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
  end

  it 'should delete a monster correctly' do
    create_monsters
    delete :destroy, params: { id: 1 }

    expect(response).to have_http_status(:see_other)
  end

  it 'should fail delete when monster does not exist' do
    delete :destroy, params: { id: 99 }

    expect(response).to have_http_status(:not_found)
    expect(JSON.parse(response.body)['message']).to eq('The monster does not exists.')
  end

  it 'should import all the CSV objects into the database successfully' do
    file = fixture_file_upload('monsters/success_case.csv')

    post(:import, params: { file: })

    expect(JSON.parse(response.body)['data']).to eq('Records were imported successfully.')
  end

  it 'should fail when importing csv file with inexistent columns' do
    file = fixture_file_upload('monsters/inexistent_columns_case.csv')

    post(:import, params: { file: })

    expect(JSON.parse(response.body)['message']).to eq('Wrong data mapping.')
  end

  it 'should fail when importing csv file with wrong columns' do
    file = fixture_file_upload('monsters/wrong_columns_case.csv')

    post(:import, params: { file: })

    expect(JSON.parse(response.body)['message']).to eq('Wrong data mapping.')
  end

  it 'should fail when importing file with different extension' do
    file = fixture_file_upload('monsters/different_extension_case.txt')

    post(:import, params: { file: })

    expect(JSON.parse(response.body)['message']).to eq('File should be csv.')
  end

  it 'should fail when importing none file' do
    post(:import)

    expect(JSON.parse(response.body)['message']).to eq('Wrong data mapping.')
  end
end
