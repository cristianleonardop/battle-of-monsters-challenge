# frozen_string_literal: true

require 'rails_helper'
require 'support/battles_helper'

RSpec.configure do |c|
  c.include BattlesHelper
end

RSpec.describe BattlesController, type: :controller do
  before(:each) do
    @monster1 = FactoryBot.create(:monster, attack: 40, defense: 20, hp: 50, speed: 80)
    @monster2 = FactoryBot.create(:monster, attack: 80, defense: 80, hp: 100, speed: 80)
    @monster3 = FactoryBot.create(:monster, attack: 80, defense: 80, hp: 100, speed: 20)
    @monster4 = FactoryBot.create(:monster, attack: 80, defense: 80, hp: 100, speed: 80)
  end

  context '#create' do
    it 'should create battle with bad request if one parameter is null' do
      expect_bad_request(nil, @monster1.id)
    end

    it 'should create battle with bad request if monster does not exists' do
      expect_bad_request(99, @monster1.id)
    end

    it 'should create battle correctly with monsterA winning' do
      expect_winner(@monster2, @monster1, @monster2)
    end

    it 'should create battle correctly with monsterB winning with equal defense and monsterB higher speed' do
      expect_winner(@monster3, @monster4, @monster4)
    end
  end
end
