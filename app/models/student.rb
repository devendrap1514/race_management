class Student < ApplicationRecord
  validates :name, presence: { message: I18n.t('active_record.errors.models.student.attributes.name.blank') }

  has_many :student_races, dependent: :destroy
  has_many :races, through: :student_races
end
