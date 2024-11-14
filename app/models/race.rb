class Race < ApplicationRecord
  validates :name, presence: true

  has_many :student_races, dependent: :destroy
  has_many :students, through: :student_races

  accepts_nested_attributes_for :student_races

  validate :duplicate_students, :duplicate_lanes, :minimum_participants, :lane_number, on: :create

  private

  def minimum_participants
    errors.add(:race, "must have at least two students") if student_races.size < 2
  end

  def duplicate_students
    has_duplicate_students = student_races.map(&:student_id).tally.any? { |_student_id, count| count > 1 }
    if has_duplicate_students
      errors.add(:student, "can't be assigned to multiple lanes in the same race")
    end
  end

  def duplicate_lanes
    has_duplicate_lanes = student_races.map(&:lane).tally.any? { |_lane, count| count > 1 }
    if has_duplicate_lanes
      errors.add(:base, "Can't assign the same lane to multiple students")
    end
  end

  def lane_number
    highest_lane = student_races.map(&:lane).compact.max
    if highest_lane && highest_lane > student_races.size
      errors.add(:base, "Lane numbers cannot exceed the number of selected students")
    end
  end
end
