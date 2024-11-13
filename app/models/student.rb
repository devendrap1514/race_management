class Student < ApplicationRecord
  validates :name, presence: { message: I18n.t('students.create.failure.name')}

  has_many :races, dependent: :destroy
  has_many :students, through: :student_races
end
