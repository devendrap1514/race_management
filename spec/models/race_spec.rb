# spec/models/race_spec.rb
require 'rails_helper'

RSpec.describe Race, type: :model do
  let(:race) { build(:race) }

  describe 'validations' do
    it 'is valid with a name' do
      expect(race).to be_valid
    end

    it 'is not valid without a name' do
      race.name = nil
      expect(race).to_not be_valid
      expect(race.errors[:name]).to include(I18n.t('active_record.errors.models.student.attributes.name.blank'))
    end

    it 'is not valid if it has fewer than two participants' do
      race.student_races = []
      race.student_races.build(student: create(:student))
      expect(race).to_not be_valid
      expect(race.errors[:base]).to include(I18n.t('active_record.errors.models.student_race.minimum_participants'))
    end

    it 'is not valid if a student is assigned to multiple lanes' do
      student1 = create(:student)
      race = build(:race, student_races_attributes: [])
      race.student_races.build(student: student1, lane: 1)
      race.student_races.build(student: student1, lane: 2)
      expect(race).to_not be_valid
      expect(race.errors[:base]).to include(I18n.t('active_record.errors.models.student_race.duplicate_students'))
    end

    it 'is not valid if a lane is assigned to multiple students' do
      student1 = create(:student)
      student2 = create(:student)
      race = build(:race, student_races_attributes: [])
      race.student_races.build(student: student1, lane: 1)
      race.student_races.build(student: student2, lane: 1)
      expect(race).to_not be_valid
      expect(race.errors[:base]).to include(I18n.t('active_record.errors.models.student_race.duplicate_lanes'))
    end
    it 'is not valid if a lane exceed the number of selected ' do
      student1 = create(:student)
      student2 = create(:student)
      race = build(:race, student_races_attributes: [])
      race.student_races.build(student: student1, lane: 1)
      race.student_races.build(student: student2, lane: 4)
      expect(race).to_not be_valid
      expect(race.errors[:base]).to include(I18n.t('active_record.errors.models.student_race.lane_number_exceed'))
    end
    it 'is not valid if positions is empty for some students' do
      race.save
      race.update(student_races_attributes: race.student_races.map.with_index { |student_race, index|
          {
            id: student_race.id,
            position: index % 2 == 1 ? nil : index+1
          }
        }
      )
      expect(race).to_not be_valid
      expect(race.errors[:base]).to include(I18n.t('active_record.errors.models.student_race.position_required'))
    end
  end

  describe 'associations' do
    it { should have_many(:student_races).dependent(:destroy) }
    it { should have_many(:students).through(:student_races) }
  end

  describe 'accepts_nested_attributes_for' do
    it 'accepts nested attributes for student_races' do
      student = create(:student)
      student1 = create(:student)
      race = Race.new(name: '100m Dash', student_races_attributes: [
        { student_id: student.id, lane: 1 },
        { student_id: student1.id, lane: 2 }
      ])
      expect(race).to be_valid
      expect(race.student_races.size).to eq(2)
    end
  end
end
