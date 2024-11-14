FactoryBot.define do
  factory :race do
    name { Faker::Name.name }
    student_races_attributes { [{student_id: create(:student).id, lane: 1}, {student_id: create(:student).id, lane: 2}] }
  end
end
