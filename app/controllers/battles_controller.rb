# frozen_string_literal: true

class BattlesController < ApplicationController
  def index
    @battles = Battle.all

    render json: { data: @battles }, status: :ok
  end

  def new
    @battle = Battle.new
  end

  def create
    @battle = Battle.new(battle_params)

    if @battle.monsterA.nil? || @battle.monsterB.nil?
      render json: { message: 'Wrong data mapping.' }, status: :bad_request
    elsif @battle.save
      render json: { data: @battle }, status: :created
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @battle = Battle.find(params[:id])

    if @battle.destroy
      redirect_to battles_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'The battle does not exists.' }, status: :not_found
  end

  private

  def battle_params
    params.require(:battle).permit(:monsterA_id, :monsterB_id)
  end
end
