class StudentRace < ApplicationRecord
  belongs_to :student
  belongs_to :race

  validates :lane, presence: {
    message: I18n.t('active_record.errors.models.student_race.attributes.lane.blank')
  }
  validates :student_id, uniqueness: {
    scope: :race_id,
    message: I18n.t('active_record.errors.models.student_race.attributes.student.uniqueness')
  }
  validates :lane, uniqueness: {
    scope: :race_id, message: I18n.t('active_record.errors.models.student_race.attributes.lane.uniqueness')
  }

  default_scope ->  { order(:position) }
end
