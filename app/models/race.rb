class Race < ApplicationRecord
  validates :name, presence: { message: I18n.t('active_record.errors.models.race.attributes.name.blank') }

  has_many :student_races, dependent: :destroy
  has_many :students, through: :student_races

  accepts_nested_attributes_for :student_races

  validate :duplicate_students, :duplicate_lanes, :minimum_participants, :lane_number, on: :create
  validate :check_positions, on: :update, unless: -> { student_races.map(&:position).compact.empty? }

  private

  def minimum_participants
    errors.add(:base, I18n.t('active_record.errors.models.student_race.minimum_participants')) if student_races.size < 2
  end

  def duplicate_students
    has_duplicate_students = student_races.map(&:student_id).tally.any? { |_student_id, count| count > 1 }
    if has_duplicate_students
      errors.add(:base, I18n.t('active_record.errors.models.student_race.duplicate_students'))
    end
  end

  def duplicate_lanes
    has_duplicate_lanes = student_races.map(&:lane).tally.any? { |_lane, count| count > 1 }
    if has_duplicate_lanes
      errors.add(:base, I18n.t('active_record.errors.models.student_race.duplicate_lanes'))
    end
  end

  def lane_number
    highest_lane = student_races.map(&:lane).compact.max
    if highest_lane && highest_lane > student_races.size
      errors.add(:base, I18n.t('active_record.errors.models.student_race.lane_number_exceed'))
    end
  end

  def check_positions
    student_races.each do |student_race|
      if student_race.position.nil?
        errors.add(:base, I18n.t('active_record.errors.models.student_race.position_required'))
        return
      end
    end
    student_ids = student_races.map(&:student_id)
    positions = student_races.map(&:position)

    service = ValidatePositionService.new(student_ids, positions)

    unless service.is_valid_position?
      errors.add(:base, service.error)
    end
  end
end
