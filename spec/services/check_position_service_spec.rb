# spec/services/check_position_service_spec.rb
require 'rails_helper'

RSpec.describe CheckPositionService do
  describe '#validate' do
    subject { described_class.new(student_ids, positions) }

    context 'when positions are valid and start from 1' do
      let(:student_ids) { [1, 2, 3] }
      let(:positions) { [1, 2, 3] }

      it 'returns true' do
        expect(subject.validate).to be true
      end

      it 'does not set an error message' do
        subject.validate
        expect(subject.error).to eq('')
      end
    end

    context 'when positions are valid with ties (e.g., 1, 1, 3)' do
      let(:student_ids) { [1, 2, 3] }
      let(:positions) { [1, 1, 3] }

      it 'returns true' do
        expect(subject.validate).to be true
      end

      it 'does not set an error message' do
        subject.validate
        expect(subject.error).to eq('')
      end
    end

    context 'when positions do not start with 1' do
      let(:student_ids) { [1, 2, 3] }
      let(:positions) { [2, 3, 4] }

      it 'returns false' do
        expect(subject.validate).to be false
      end

      it 'sets an error message indicating positions should start with 1' do
        subject.validate
        expect(subject.error).to eq('Position should start with 1')
      end
    end

    context 'when positions have an invalid sequence (e.g., 1, 1, 2 instead of 1, 1, 3)' do
      let(:student_ids) { [1, 2, 3] }
      let(:positions) { [1, 1, 2] }

      it 'returns false' do
        expect(subject.validate).to be false
      end

      it 'sets an error message about the correct next position for ties' do
        subject.validate
        expect(subject.error).to eq('Invalid positions: Tied athletes must be followed by the correct next position, e.g., 1, 1, 3')
      end
    end

    context 'when there are multiple ties but the sequence is correct (e.g., 1, 1, 3, 3, 5)' do
      let(:student_ids) { [1, 2, 3, 4, 5] }
      let(:positions) { [1, 1, 3, 3, 5] }

      it 'returns true' do
        expect(subject.validate).to be true
      end

      it 'does not set an error message' do
        subject.validate
        expect(subject.error).to eq('')
      end
    end

    context 'when no students or positions are provided' do
      let(:student_ids) { [] }
      let(:positions) { [] }

      it 'returns false' do
        expect(subject.validate).to be true
      end
    end
  end
end
