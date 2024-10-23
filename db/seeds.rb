# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |n|
  User.create(
    email: "test#{n+1}@test.com",
    name: "テスト#{n+1}",
    password: "test0#{n+1}",
    )
end
  

stars_hist = ['bad', 'poor', 'regular', 'good', 'gorgeous']
5.times do |n|
  Book.create(
    title: "test#{n+1}",
    body: "#{n+1}回読みました",
    user_id: n+1,
    category: "category#{rand(1..5)}",
    rate: "#{rand(1..5)}",
  )
end

# relation(相互)
User.find(1).follow(User.find(3))
User.find(3).follow(User.find(1))

# relation(一方通行)
User.find(2).follow(User.find(4))
5.times do |n|
  Group.create(
    name: "sample#{n+1}",
    introduction: "sample#{n+1} introduction",
    owner_id: n+1,
  )

  GroupUser.create!(
    user_id: n+1,
    group_id: n+1
  )
end


Group.find(1).users << User.find(2)
Group.find(1).users << User.find(3)
