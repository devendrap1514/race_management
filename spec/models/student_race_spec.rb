require 'rails_helper'

RSpec.describe StudentRace, type: :model do
  let(:student1) { create(:student) }
  let(:student2) { create(:student) }
  let(:race) { create(:race, student_races_attributes: [{student_id: student1.id, lane: 1}, {student_id: student2.id, lane: 2}]) }

  describe 'validations' do
    it 'is valid with a student, race, and lane' do
      student_race = build(:student_race, race: race, student: create(:student), lane: 3)
      expect(student_race).to be_valid
    end

    context 'when lane is not present' do
      it 'is invalid' do
        student_race = build(:student_race, lane: nil)
        expect(student_race).not_to be_valid
        expect(student_race.errors[:lane]).to include(
          I18n.t('active_record.errors.models.student_race.attributes.lane.blank')
        )
      end
    end

    context 'when student is assigned to the same race multiple times' do
      it 'is invalid' do
        another_student_race = build(:student_race, student: student1, race: race, lane: 3)
        expect(another_student_race).not_to be_valid
        expect(another_student_race.errors[:student_id]).to include(
          I18n.t('active_record.errors.models.student_race.attributes.student.uniqueness')
        )
      end
    end

    context 'when lane is already taken in the same race' do
      it 'is invalid' do
        another_student_race = build(:student_race, lane: 1)
        expect(another_student_race).not_to be_valid
        expect(another_student_race.errors[:lane]).to include(
          I18n.t('active_record.errors.models.student_race.attributes.lane.uniqueness')
        )
      end
    end
  end

  describe 'default scope' do
    it 'orders by position' do
      race
      StudentRace.all.map.with_index { |stu, index| stu.update(position: index+1) }
      expect(StudentRace.all.pluck(:position)).to eq([1, 2])
    end
  end

  describe 'associations' do
    it { should belong_to(:student) }
    it { should belong_to(:race) }
  end
end
