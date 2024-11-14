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
      redirect_to races_path, notice: I18n.t('race.created')
    else
      flash.now[:alert] = @race.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit; end

  def update
    student_ids = params[:student_ids]
    positions = params[:positions]

    if student_ids.size != positions.size
      return redirect_to edit_race_path(@race), alert: I18n.t('race.position_required')
    end

    check_position = CheckPositionService.new(student_ids, positions)
    unless check_position.validate
      return redirect_to edit_race_path(@race), alert: check_position.error
    end

    if update_positions(student_ids, positions)
      redirect_to races_path, notice: t('race.updated')
    else
      redirect_to edit_race_path(@race), alert: I18n.t('race.invalid_student_data')
    end
  end

  def destroy
    @race.destroy
    redirect_to races_path, notice: I18n.t('race.deleted')
  end

  private

  def race_params
    params.require(:race).permit(:name, student_races_attributes: %i[student_id lane])
  end

  def set_race
    @race = Race.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to races_path, alert: I18n.t('race.not_found')
  end

  def load_students
    @students = Student.all
  end

  def update_positions(student_ids, positions)
    positions.each_with_index do |position, index|
      student_race = @race.student_races.find_by(student_id: student_ids[index])
      return false unless student_race&.update(position: position)
    end
    true
  end
end
