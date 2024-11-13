class StudentRace < ApplicationRecord
  belongs_to :student
  belongs_to :race

  validates :lane, presence: true
end
