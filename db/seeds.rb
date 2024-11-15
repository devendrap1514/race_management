5.times {
  Student.find_or_create_by(name: Faker::Name.name)
}
