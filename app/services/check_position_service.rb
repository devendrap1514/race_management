class CheckPositionService
  attr_accessor :error

  def initialize(student_ids, positions)
    @student_ids = student_ids.map(&:to_i)
    @positions = positions.map(&:to_i)
    @error = ''
  end

  def validate
    student_positions = @student_ids.zip(@positions).map { |id, pos| { student_id: id, position: pos } }
    sorted_students = student_positions.sort_by { |student| student[:position] }

    return invalid_position_error if sorted_students.first[:position] != 1

    expected_position = 1

    sorted_students.each do |student|
      if student[:position] != expected_position
        @error = "Invalid positions: Tied athletes must be followed by the correct next position, e.g., 1, 1, 3"
        return false
      end
      expected_position += 1 unless student_positions.count { |s| s[:position] == expected_position } > 1
    end

    true
  end

  private

  def invalid_position_error
    @error = 'Position should start with 1'
    false
  end
end
