User.create!(email: 'b.buetikofer+a@outlook.com', username: 'Admin', password: 'password', password_confirmation: 'password', confirmed_at: Time.now)
User.create!(email: 'editor@example.com', username: 'Editor', password: 'password', password_confirmation: 'password')
User.create!(email: 'contributor@example.com', username: 'Contributor', password: 'password', password_confirmation: 'password')

30.times do
  Entry.create!([{
                  title: Faker::Educator.course_name,
                  description: Faker::TvShows::GameOfThrones.quote,
                  user_id: User.first.id
                }])
end

3.times do
  Entry.create!([{
                  title: Faker::Educator.course_name,
                  description: Faker::TvShows::GameOfThrones.quote,
                  user_id: User.first.id,
                  draft: true
                }])
end