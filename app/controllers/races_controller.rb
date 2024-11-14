class RacesController < ApplicationController
  before_action :set_race, only: %i[destroy]

  def index
    @races = Race.all
  end

  def new
    @students = Student.all
    @race = Race.new
  end

  def create
    @race = Race.new(race_params)

    if @race.save
      redirect_to races_path, notice: I18n.t('race.created')
    else
      flash.now[:alert] = @race.errors.full_messages.to_sentence
      @students = Student.all
      render :new
    end
  end

  def destroy
    @race.destroy
    redirect_to races_path, notice: I18n.t('race.deleted')
  end

  private

  def race_params
    params.require(:race).permit(:name, student_races_attributes: [:student_id, :lane])
  end

  def set_race
    @race = Race.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to races_path, alert: I18n.t('race.not_found')
  end
end
