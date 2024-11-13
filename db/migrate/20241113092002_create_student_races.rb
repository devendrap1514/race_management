class CreateStudentRaces < ActiveRecord::Migration[8.0]
  def change
    create_table :student_races do |t|
      t.references :student, null: false, foreign_key: true
      t.references :race, null: false, foreign_key: true
      t.integer :lane
      t.integer :position

      t.timestamps
    end
  end
end
