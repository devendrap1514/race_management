class Student < ApplicationRecord
  validates :name, presence: { message: I18n.t('students.create.failure.name')}

  has_many :student_races, dependent: :destroy
  has_many :races, through: :student_races
end
