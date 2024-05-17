# frozen_string_literal: true

class Battle < ApplicationRecord
  belongs_to :monsterA, class_name: 'Monster'
  belongs_to :monsterB, class_name: 'Monster'
  belongs_to :winner, class_name: 'Monster'

  before_validation :start_battle

  private

  def start_battle
    first_attacker, second_attacker = attacker_order

    self.winner = battle(first_attacker, second_attacker)
  end

  def attacker_order_by(stats_a, stats_b)
    first_attacker = stats_a > stats_b ? monsterA : monsterB
    second_attacker = first_attacker == monsterA ? monsterB : monsterA

    [first_attacker, second_attacker]
  end

  def attacker_order
    return attacker_order_by(monsterA.attack, monsterB.attack) if monsterA.speed == monsterB.speed

    attacker_order_by(monsterA.speed, monsterB.speed)
  end

  def battle(attacker, attacked)
    attack = attacker.attack
    defense = attacked.defense

    calculated_damage = attack - defense

    damage = calculated_damage.positive? ? calculated_damage : 1
    attacked.hp = attacked.hp - damage

    battle(attacked, attacker) if attacked.hp.positive?

    attacker
  end
end
