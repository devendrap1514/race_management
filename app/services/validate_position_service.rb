class ValidatePositionService
  attr_accessor :error

  def initialize(student_ids, positions)
    @student_ids = student_ids.map(&:to_i)
    @positions = positions.map(&:to_i)
    @error = ''
  end

  def is_valid_position?
    student_positions = @student_ids.zip(@positions).map { |id, pos| { student_id: id, position: pos } }
    sorted_students = student_positions.sort_by { |student| student[:position] }

    last_position = 1
    sorted_students.each_with_index do |student, index|
      if index == 0 && student[:position] != 1
        @error = I18n.t('active_record.errors.models.student_race.start_position')
        return false
      else
        if student[:position] == last_position
          next
        elsif student[:position] == index + 1
          last_position = student[:position]
        else
          @error = I18n.t('active_record.errors.models.student_race.invalid_positions')
          return false
        end
      end
    end
    true
  end
end
