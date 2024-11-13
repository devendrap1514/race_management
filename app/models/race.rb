class Race < ApplicationRecord
  validates :name, presence: true

  has_many :student_races, dependent: :destroy
  has_many :students, through: :student_races

  accepts_nested_attributes_for :student_races

  validate :minimum_participants, :no_duplicate_students, :no_duplicate_lanes, on: :create

  private

  def minimum_participants
    errors.add(:race, "must have at least two students") if student_races.size < 2
  end

  def no_duplicate_students
    has_duplicate_students = student_races.map(&:student_id).tally.any? { |_student_id, count| count > 1 }
    if has_duplicate_students
      errors.add(:student, "can't be assigned to multiple lanes in the same race")
    end
  end

  def no_duplicate_lanes
    has_duplicate_lanes = student_races.map(&:lane).tally.any? { |_lane, count| count > 1 }
    if has_duplicate_lanes
      errors.add(:base, "can't assign the same lane to multiple students")
    end
  end
end
