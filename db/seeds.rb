30.times do
  Entry.create!([{
                  title: Faker::Educator.course_name,
                  description: Faker::TvShows::GameOfThrones.quote
                }])
end