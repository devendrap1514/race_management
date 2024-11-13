class StudentsController < ApplicationController
  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to new_student_path, notice: I18n.t('students.create.success')
    else
      redirect_to new_student_path, alert: @student.errors[:name].first
    end
  end

  private

  def student_params
    params.require(:student).permit(:name)
  end
end
