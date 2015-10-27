# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(
  email: 'brandon@sonerdy.com',
  provider: 'github',
  uid: '46870',
  token: '5b87cf14804e55b0d0b252fa5e5b877d3860732c',
  full_name: 'Brandon Joyce',
  image: 'https://avatars.githubusercontent.com/u/46870?v=3',
  nickname: 'BrandonJoyce356',
)

User.create!(
  email: 'brandonjoyce356@hotmail.com',
  provider: 'github',
  uid: '4210762',
  token: 'f543ee6d25529089bf307e531109b16beba8b2c5',
  full_name: 'EvilWhiteHot',
  image: 'https://avatars.githubusercontent.com/u/4210762?v=3',
  nickname: 'EvilWhiteHot',
)
