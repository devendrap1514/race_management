class RacesController < ApplicationController
  before_action :set_race, only: %i[edit update destroy]
  before_action :load_students, only: %i[new create]

  def index
    @races = Race.all
  end

  def new
    @race = Race.new
  end

  def create
    @race = Race.new(race_params)

    if @race.save
      redirect_to races_path, notice: I18n.t('message.create.race')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @race.update(update_race_params)
      redirect_to races_path, notice: t('message.update.race')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @race.destroy
    redirect_to races_path, notice: I18n.t('message.delete.race')
  end

  private

  def race_params
    params.require(:race).permit(:name, student_races_attributes: %i[student_id lane])
  end

  def update_race_params
    params.require(:race).permit(student_races_attributes: %i[id position])
  end

  def set_race
    @race = Race.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to races_path, alert: I18n.t('message.not_found.race')
  end

  def load_students
    @students = Student.all
  end
end
