require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:student) { build(:student) }

  describe 'validations' do
    it 'is valid with a name' do
      expect(student).to be_valid
    end

    it 'is not valid without a name' do
      student.name = nil
      expect(student).to_not be_valid
      expect(student.errors[:name]).to include(I18n.t('active_record.errors.models.student.attributes.name.blank'))
    end
  end

  describe 'associations' do
    it { should have_many(:races).through(:student_races) }
    it { should have_many(:student_races).dependent(:destroy) }
  end
end
