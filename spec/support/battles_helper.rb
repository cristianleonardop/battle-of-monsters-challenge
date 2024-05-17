# frozen_string_literal: true

module BattlesHelper
  def expect_winner(monster_a, monster_b, winner)
    battle_attributes = { monsterA_id: monster_a.id, monsterB_id: monster_b.id }

    post :create, params: { battle: battle_attributes }

    response_data = JSON.parse(response.body)['data']

    expect(response).to have_http_status(:created)
    expect(response_data['winner_id']).to eq(winner.id)
  end

  def expect_bad_request(monster_a, monster_b)
    battle_attributes = { monsterA_id: monster_a, monsterB_id: monster_b }

    post :create, params: { battle: battle_attributes }

    expect(response).to have_http_status(:bad_request)
  end
end
