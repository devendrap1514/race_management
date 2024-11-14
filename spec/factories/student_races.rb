FactoryBot.define do
  factory :student_race do
    race { create(:race) }
    student { create(:student) }
    lane { 1 }
  end
end
