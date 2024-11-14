FactoryBot.define do
  factory :student, class: 'Student' do
    name { Faker::Name.name }
  end
end
