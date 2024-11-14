require 'rails_helper'

RSpec.describe StudentRace, type: :model do
  describe 'validations' do
    it 'is valid with a student, race, and lane' do
      student_race = build(:student_race)
      expect(student_race).to be_valid
    end

    it 'is not valid without a lane' do
      student_race = build(:student_race, lane: nil)
      expect(student_race).to_not be_valid
      expect(student_race.errors[:lane]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it { should belong_to(:student) }
    it { should belong_to(:race) }
  end
end
