User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

30.times do
  Entry.create!([{
                  title: Faker::Educator.course_name,
                  description: Faker::TvShows::GameOfThrones.quote,
                  user_id: User.first.id,
                }])
end
