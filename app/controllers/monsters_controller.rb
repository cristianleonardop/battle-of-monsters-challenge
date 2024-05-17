# frozen_string_literal: true

class MonstersController < ApplicationController
  require 'csv'

  def index
    @monsters = Monster.all

    render json: { data: @monsters }, status: :ok
  end

  def new
    @monster = Monster.new
  end

  def show
    @monster = Monster.find(params[:id])

    render json: { data: @monster }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'The monster does not exists.' }, status: :not_found
  end

  def create
    @monster = Monster.new(monster_params)

    if @monster.save
      render json: { data: @monster }, status: :created
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @monster = Monster.find(params[:id])
  end

  def update
    @monster = Monster.find(params[:id])

    if @monster.update(monster_params)
      render json: { data: @monster }, status: :ok
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'The monster does not exists.' }, status: :not_found
  end

  def destroy
    @monster = Monster.find(params[:id])

    if @monster.destroy
      redirect_to root_path, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'The monster does not exists.' }, status: :not_found
  end

  def import
    file = params[:file]

    if file
      ext = File.extname(file.original_filename)
      unless ['.csv'].include?(ext)
        return render json: { message: 'File should be csv.' }, status: :bad_request
      end

      import_monsters(file.tempfile)
    else
      render json: { message: 'Wrong data mapping.' }, status: :bad_request
    end
  end

  private

  def monster_params
    params.require(:monster)
          .permit(:name, :imageUrl, :attack, :defense, :hp, :speed)
  end

  def import_monsters(handle)
    return unless handle

    row_data = []
    row_data << CSV.parse_line(handle.gets) until handle.eof?
    csv_data = row_data[1..]

    CsvImportService.new.import_monster(row_data, csv_data)

    render json: { data: 'Records were imported successfully.' }, status: :ok
  rescue ActiveRecord::StatementInvalid
    render json: { message: 'Wrong data mapping.' }, status: :bad_request
  rescue StandardError
    render json: { message: 'Wrong data mapping.' }, status: :bad_request
  end
end
