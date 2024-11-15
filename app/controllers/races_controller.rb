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
    positions = params[:positions].reject(&:blank?)

    unless student_ids.size == positions.size
      set_flash_message(:alert, I18n.t('race.position_required'))
      return render :edit
    end

    position = ValidatePositionService.new(student_ids, positions)
    unless position.is_valid_position?
      set_flash_message(:alert, position.error)
      return render :edit
    end

    if positions_updated?(student_ids, positions)
      redirect_to races_path, notice: t('race.updated')
    else
      set_flash_message(:alert, I18n.t('race.invalid_student_data'))
      render :edit
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

  def positions_updated?(student_ids, positions)
    positions.each_with_index do |position, index|
      student_race = @race.student_races.find_by(student_id: student_ids[index])
      return false unless student_race&.update(position: position)
    end
    true
  end

  def set_flash_message(type, message)
    flash.now[type] = message
  end
end
